//
//  ChatViewModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import InputBarAccessoryView
import OpenAISwift
import UIKit

protocol MessageStorageDelegate: AnyObject {
    func insert(message: Message)
    func fetchMessages() -> [Message]
}

final class ChatViewModel {
    
    private enum OpenAIPrompt {
        static let openAISystemPrompt: String = """
            당신은 사용자가 입력한 키워드에 기반해서 3개의 여행지를 추천해주는 챗봇입니다.
            차근차근 생각해 봅시다.

            step 1. 사용자가 최소 2개 이상의 키워드를 선택합니다. 키워드에 "국내"가 있다면 "국내"는 "한국"을, "해외"가 있다면 해외는 "한국 외 국가"를 의미합니다.
            step 2. 여행 주제의 문서들 내에 해당 키워드와 자주 등장하거나 높은 유사도를 갖는 여행지를 오름차순으로 정렬하여 세 곳의 여행지를 선별합니다.
            step 3. 사용자에게 답변할 내용이 여행지 추천인 경우 답변은 JSON 형태로 반환합니다. recommendationItems의 country에 여행지의 국가를, spot에 관련 명소를 할당해 반환합니다.

            아래의 예시를 참고하세요:
            Q: 오늘은 어디로 여행을 떠나고 싶나요? 사진을 보내주시면 원하는 분위기의 여행지를 추천해드릴게요! 키워드를 선택해주세요!
            A: 해외, 레저, 휴식
            Q:
            {
              "recommendationItems": [
                {
                  "country": "태국",
                  "spot": "후아힌 해변"
                },
                {
                  "country": "인도네시아",
                  "spot": "발리 Tegenungan Waterfall"
                },
                {
                  "country": "말레이시아",
                  "spot": "쿠알라룸푸르 선웨이라군 워터파크"
                }
              ]
            }
            """
    }
    
    private struct OpenAIRecommendation: Decodable {
        
        struct RecommendationItem: Decodable {
            let country: String
            let spot: String
        }
        
        let recommendationItems: [RecommendationItem]
    }
    
    weak var coordinator: ChatCoordinator?
    weak var delegate: MessageStorageDelegate?
    var didTapImageUploadButton: (() -> Void)?
    
    private let user: Sender = Sender(name: .user)
    private let ai: Sender = Sender(name: .ai)
    private let chatUseCase: ChatUseCase
    private let openAIUseCase: OpenAIUseCase
    private let imageSearchUseCase: ImageSearchUseCase
    private var selectedTags: [Tag] = []
    private var recommendationItems: [RecommendationItem] = []
    private var openAIChatMessages: [ChatMessage] = []
    
    // MARK: Lifecycle
    
    init(
        chatUseCase: ChatUseCase,
        openAIUseCase: OpenAIUseCase,
        imageSearchUseCase: ImageSearchUseCase)
    {
        self.chatUseCase = chatUseCase
        self.openAIUseCase = openAIUseCase
        self.imageSearchUseCase = imageSearchUseCase
        addDefaultOpenAIPropmpt()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTapImageUploadButton(notification:)),
            name: .imageUploadButtonTapped,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(submitSelectedTags(notification:)),
            name: .tagSubmitButtonTapped,
            object: nil)
    }
    
    // MARK: Internal
    
    func makePhotoMessage(_ image: UIImage) {
        let message = Message(
            image: image,
            sender: user,
            sentDate: Date())
        insertMessage(message)
    }
    
    func backButtonTapped() -> (viewModel: PopUpViewModel, type: PopUpContentView.PopUpType) {
        let popUpViewModel = createPopUpViewModel()
        let popUpModel = createPopUpModel()
        
        return (viewModel: popUpViewModel, type: .normal(popUpModel))
    }
    
    func saveChat() {
        guard let messages = delegate?.fetchMessages(),
              isValidChat()
        else { return }
        
        let chat = createChat(with: messages)
        chatUseCase.save(chat: chat) { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func pop() {
        coordinator?.finish()
    }
    
    // MARK: Private
    
    private func insertMessage(_ message: Message) {
        delegate?.insert(message: message)
    }
    
    private func createRecommendationMessage(with result: OpenAIRecommendation) -> Message {
        let items = result.recommendationItems
        items.forEach { createRecommendationItem(with: $0) }
        
        return Message(recommendations: recommendationItems)
    }
    
    private func createRecommendationItem(with item: OpenAIRecommendation.RecommendationItem) {
        imageSearchUseCase.searchImage(with: selectedTags, spot: item.spot) { [weak self] result in
            switch result {
            case .success(let imageData):
                let recommendationItem = RecommendationItem(
                    country: item.country,
                    spot: item.spot,
                    image: imageData)
                self?.recommendationItems.append(recommendationItem)
            case .failure(let error):
                print(error)
            }
        }
    }
    private func addDefaultOpenAIPropmpt() {
        let message = ChatMessage(role: .system, content: OpenAIPrompt.openAISystemPrompt)
        openAIChatMessages.append(message)
    }
    
    private func sendSelectedTags(_ tagText: String) {
        let message = ChatMessage(role: .user, content: tagText)
        sendMessageToOpenAI(message)
    }
    
    private func sendMessageToOpenAI(_ message: ChatMessage) {
        // TODO: - 챗지피티에 메시지 발송할 때 항상 답변 생성 애니메이션 넣어야 함
        openAIChatMessages.append(message)
        openAIUseCase.send(chatMessages: openAIChatMessages) { [weak self] result in
            switch result {
            case .success(let chatMessages):
                self?.openAIChatMessages.append(contentsOf: chatMessages)
                self?.configureOpenAIResponse(chatMessages)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureOpenAIResponse(_ messages: [ChatMessage]) {
        guard let messageContent = messages.first?.content,
              let messageContentData = messageContent.data(using: .utf8)
        else { return }
        
        // ChatGPT의 답변이 장소 추천인지, 일반 텍스트인지 구분
        do {
            let openAIRecommendation = try JSONDecoder().decode(OpenAIRecommendation.self, from: messageContentData)
            let recommendationMessage = createRecommendationMessage(with: openAIRecommendation)
            insertMessage(recommendationMessage)
        } catch {
            let textMessage = createTextMessage(with: messageContent, sender: ai)
            insertMessage(textMessage)
        }
    }
    
    private func createTextMessage(with text: String, sender: Sender) -> Message {
        let textColor: UIColor = sender == ai ? .black : .white
        let messageText = NSMutableAttributedString()
            .text(text, font: .bodyRegular, color: textColor)
        return Message(
            text: messageText,
            sender: sender,
            sentDate: Date())
    }
    
    // TODO: - 사진 API를 통해 사진 가져와서 RecommendationItem 생성
    private func createRecommendationMessage(with result: OpenAIRecommendation) -> Message {
        
        // 메시지는 [RecommendationItem]을 받아서 만든다.
        return Message(sender: ai, sentDate: Date())
    }
    
    private func createPopUpViewModel() -> PopUpViewModel {
        return PopUpViewModel()
    }
    
    private func createPopUpModel() -> PopUpModel {
        let mainText = NSMutableAttributedString()
            .text("대화를 종료하시겠습니까?\n", font: .bodyRegular, color: .black)
            .text("종료하시면 이 대화는 ", font: .bodyRegular, color: .black)
            .text("자동으로 종료", font: .bodyBold, color: .primary)
            .text("되니 주의 부탁 드려요!", font: .bodyRegular, color: .black)
        let leftButtonTitle = NSMutableAttributedString()
            .text("네", font: .bodyRegular, color: .white)
        let rightButtonTitle = NSMutableAttributedString()
            .text("아니요", font: .bodyRegular, color: .black)
        
        return PopUpModel(
            mainText: mainText,
            leftButtonTitle: leftButtonTitle,
            rightButtonTitle: rightButtonTitle)
    }
    
    private func isValidChat() -> Bool {
        return !selectedTags.isEmpty && !recommendationItems.isEmpty
    }
    
    private func createChat(with messages: [Message]) -> Chat {
        let tagItem = TagItem(tags: selectedTags)

        return Chat(
            id: UUID(),
            createdAt: Date(),
            tags: tagItem,
            recommendations: recommendationItems,
            messages: messages)
    }
    
    // MARK: objc methods
    
    @objc private func didTapImageUploadButton(notification: Notification) {
        didTapImageUploadButton?()
    }

    @objc private func submitSelectedTags(notification: Notification) {
        guard let selectedTags = notification.userInfo?[NotificationKey.selectedTags] as? [Tag] else { return }
        
        let tagText = selectedTags.map { $0.value }.joined(separator: ", ")
        let selectedTagTextMessage = createTextMessage(with: tagText, sender: user)
        self.selectedTags = selectedTags
        insertMessage(selectedTagTextMessage)
        sendSelectedTags(tagText)
    }
}

// MARK: InputBarAccessoryViewDelegate

extension ChatViewModel: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let textMessage = createTextMessage(with: text, sender: user)
        let openAIChatMessage = ChatMessage(role: .user, content: text)
        insertMessage(textMessage)
        sendMessageToOpenAI(openAIChatMessage)
    }
}
