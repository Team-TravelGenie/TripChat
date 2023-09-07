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

protocol ButtonStateDelegate: AnyObject {
    func setUploadButtonState(_ isEnabled: Bool)
    func setTagCellButtonState(_ isEnabled: Bool)
}

final class ChatViewModel {
    
    private enum Constant {
        static let welcomeText = "오늘은 어디로 여행을 떠나고 싶나요? 사진을 보내주시면 원하는 분위기의 여행지를 추천해드릴게요!"
        
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
    weak var messageStorageDelegate: MessageStorageDelegate?
    weak var buttonStateDelegate: ButtonStateDelegate?
    var didTapImageUploadButton: (() -> Void)?
    
    private let ai: Sender = Sender(name: .ai)
    private let user: Sender = Sender(name: .user)
    private let chatUseCase: ChatUseCase
    private let openAIUseCase: OpenAIUseCase
    private let imageSearchUseCase: ImageSearchUseCase
    private let googleVisionUseCase: GoogleVisionUseCase
    private let visionResultProcessor = VisionResultProcessor()
    private var selectedTags: [Tag] = []
    private var openAIChatMessages: [ChatMessage] = []
    private var recommendationItems: [RecommendationItem] = []
    
    // MARK: Lifecycle
    
    init(
        chatUseCase: ChatUseCase,
        openAIUseCase: OpenAIUseCase,
        imageSearchUseCase: ImageSearchUseCase,
        googleVisionUseCase: GoogleVisionUseCase)
    {
        self.chatUseCase = chatUseCase
        self.openAIUseCase = openAIUseCase
        self.imageSearchUseCase = imageSearchUseCase
        self.googleVisionUseCase = googleVisionUseCase
        addDefaultOpenAIPropmpt()
        registerNotificationObservers()
    }
    
    // MARK: Internal
    
    func insertMessage(_ message: Message) {
        messageStorageDelegate?.insert(message: message)
    }
    
    func handlePhotoUploads(images: [UIImage]) {
        let totalPhotosToUpload = images.count
        var photoUploadCount = 0
        
        images.forEach {
            let photoMessage = createPhotoMessage(from: $0)
            photoUploadCount += 1
            insertMessage(photoMessage)
        }

        if totalPhotosToUpload == photoUploadCount {
            updateUploadButtonState(false)
            extractKeywordsFromImages(images: images)
        }
    }
    
    func backButtonTapped() -> (viewModel: PopUpViewModel, type: PopUpContentView.PopUpType) {
        let popUpViewModel = createPopUpViewModel()
        let popUpModel = createPopUpModel()
        
        return (viewModel: popUpViewModel, type: .normal(popUpModel))
    }
    
    func saveChat() {
        guard let messages = messageStorageDelegate?.fetchMessages(),
              isValidChat()
        else { return }
        
        let chat = createChat(with: messages)
        chatUseCase.save(chat: chat) { error in
            print(error?.localizedDescription)
        }
    }
    
    func pop() {
        coordinator?.finish()
    }
    
    // MARK: Private
    
    private func registerNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTapImageUploadButton(notification:)),
            name: .imageUploadButtonTapped,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTapTagSubmitButton(notification:)),
            name: .tagSubmitButtonTapped,
            object: nil)
    }
    
    func setupDefaultSystemMessages() {
        let defaultMessage = NSMutableAttributedString()
            .text(Constant.welcomeText, font: .bodyRegular, color: .black)
        
        let defaultMessages = [
            Message(sender: Sender(name: .ai)),
            Message(text: defaultMessage, sender: Sender(name: .ai), sentDate: Date()),
            Message(sender: Sender(name: .ai))
        ]
        
        defaultMessages.forEach { insertMessage($0) }
    }
    
    private func updateUploadButtonState(_ isEnabled: Bool) {
        buttonStateDelegate?.setUploadButtonState(isEnabled)
    }
    
    private func extractKeywordsFromImages(images: [UIImage]) {
        let group = DispatchGroup()
        
        images.forEach {
            if let base64String = convertImageToBase64(image: $0) {
                group.enter()
                fetchKeywordsFromGoogleVision(base64String: base64String) {
                    group.leave()
                }
                
                group.enter()
                fetchLandMarksFromGoogleVision(base64String: base64String) {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .global(qos: .userInteractive)) { [weak self] in
            guard let self else { return }
            
            self.visionResultProcessor.getSixMostConfidentTranslatedTags() { [weak self] in
                guard let self else { return }
                let defaultTags = self.makeDefaultTags()
                let appendedTags = defaultTags + $0
                let tagMessage = self.createTagMessage(from: appendedTags)
                
                insertMessage(tagMessage)
            }
        }
    }
    
    private func makeDefaultTags() -> [Tag] {
        return [
            Tag(category: .location, value: "국내"),
            Tag(category: .location, value: "해외")]
    }

    private func convertImageToBase64(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("base64String 인코딩오류")
            return nil
        }
        
        return imageData.base64EncodedString()
    }

    private func fetchKeywordsFromGoogleVision(base64String: String, completion: @escaping () -> Void) {
        googleVisionUseCase.extractKeywords(base64String) { result in
            switch result {
            case .success(let keywords):
                self.visionResultProcessor.addKeywords(keywords.labels)
            case .failure(let error):
                print(error)
            }
            
            completion()
        }
    }
    
    private func fetchLandMarksFromGoogleVision(base64String: String, completion: @escaping () -> Void) {
        googleVisionUseCase.extractLandmarks(base64String) { result in
            switch result {
            case .success(let landmarks):
                self.visionResultProcessor.addLandmarks(landmarks.landmarks)
            case .failure(let error):
                print(error)
            }
            
            completion()
        }
    }
    
    // MARK: Create Message
    
    private func createTextMessage(with text: String, sender: Sender) -> Message {
        let messageText = NSMutableAttributedString()
            .messageText(text, font: .bodyRegular, sender: sender)
        return Message(
            text: messageText,
            sender: sender,
            sentDate: Date())
    }
    
    private func createPhotoMessage(from image: UIImage) -> Message {
        return Message(
            image: image,
            sender: user,
            sentDate: Date())
    }
    
    private func createTagMessage(from tags: [Tag]) -> Message {
        return Message(tags: tags)
    }
    
    private func insertRecommendationMessage(with result: OpenAIRecommendation) {
        let items = result.recommendationItems
        let group = DispatchGroup()
        
        for item in items {
            group.enter()
            createRecommendationItem(with: item) { [weak self] recommendationItem in
                self?.recommendationItems.append(recommendationItem)
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            let message = Message(recommendations: self.recommendationItems)
            insertMessage(message)
        }
    }
    
    private func createRecommendationItem(
        with item: OpenAIRecommendation.RecommendationItem,
        completion: @escaping ((RecommendationItem) -> Void))
    {
        imageSearchUseCase.searchImage(with: selectedTags, spot: item.spot) { result in
            switch result {
            case .success(let imageData):
                let recommendationItem = RecommendationItem(
                    country: item.country,
                    spot: item.spot,
                    image: imageData)
                completion(recommendationItem)
            case .failure:
                let recommendationItem = RecommendationItem(
                    country: item.country,
                    spot: item.spot,
                    image: Data())
                completion(recommendationItem)
            }
        }
    }
    
    // MARK: OpenAI
    
    private func addDefaultOpenAIPropmpt() {
        let message = ChatMessage(role: .system, content: Constant.openAISystemPrompt)
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
            insertRecommendationMessage(with: openAIRecommendation)
        } catch {
            let textMessage = createTextMessage(with: messageContent, sender: ai)
            insertMessage(textMessage)
        }
    }
    
    // MARK: PopUp
    
    private func createPopUpViewModel() -> PopUpViewModel {
        return PopUpViewModel(
            selectedTags: selectedTags,
            recommendationItem: recommendationItems,
            userFeedbackUseCase: DefaultUserFeedbackUseCase(
                userFeedbackRepository: DefaultUserFeedbackRepository(
                    userFeedbackStorage: FirebaseUserFeedbackStorage()))
        )
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

    // MARK: Chat
    
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

    @objc private func didTapTagSubmitButton(notification: Notification) {
        guard let selectedTags = notification.userInfo?[NotificationKey.selectedTags] as? [Tag] else { return }
        
        self.selectedTags = selectedTags
        
        let tagText = selectedTags.map { $0.value }.joined(separator: ", ")
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
