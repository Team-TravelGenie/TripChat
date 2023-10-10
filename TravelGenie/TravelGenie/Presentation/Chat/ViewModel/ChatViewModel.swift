//
//  ChatViewModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import Foundation
import InputBarAccessoryView
import OpenAISwift

protocol MessageStorageDelegate: AnyObject {
    func insert(message: Message)
    func fetchMessages() -> [Message]
    func updateTagMessage(selectedTags: [Tag])
    func removeLoadingMessage()
}

protocol ButtonStateDelegate: AnyObject {
    func setUploadButtonState(_ isEnabled: Bool)
    func setTagMessageInteractionState(submitButtonState: Bool, interactionState: Bool)
}

protocol InputBarStateDelegate: AnyObject {
    func setPhotosButtonState(_ isEnabled: Bool)
    func updateInputTextViewState(_ isEditable: Bool)
}

final class ChatViewModel {
    weak var coordinator: ChatCoordinator?
    weak var buttonStateDelegate: ButtonStateDelegate?
    weak var inputBarStateDelegate: InputBarStateDelegate?
    weak var messageStorageDelegate: MessageStorageDelegate?
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
    
    func setupDefaultSystemMessages() {
        let defaultMessage = NSMutableAttributedString()
            .text(Constant.welcomeText, font: .bodyRegular, color: .black)
        
        let defaultMessages = [
            Message(sender: Sender(name: .ai)),
            Message(text: defaultMessage, sender: Sender(name: .ai), sentDate: Date()),
            Message(sender: Sender(name: .ai))
        ]
        
        defaultMessages.forEach { insertMessage($0) }
        updateInputTextViewState(isEditable: false)
    }
    
    func insertMessage(_ message: Message) {
        messageStorageDelegate?.insert(message: message)
    }
    
    func backButtonTapped() -> (viewModel: PopUpViewModel, type: PopUpContentView.PopUpType) {
        let popUpViewModel = createPopUpViewModel()
        let popUpModel = createPopUpModel()
        
        return (viewModel: popUpViewModel, type: .normal(popUpModel))
    }
    
    func saveChat() {
        guard var messages = messageStorageDelegate?.fetchMessages(),
              isValidChat()
        else { return }
        
        if let lastMessage = messages.last,
           lastMessage.messageId == "loading"
        {
            messages.removeLast()
        }
        

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
    
    private func updateImageUploadButtonState(_ isEnabled: Bool) {
        buttonStateDelegate?.setUploadButtonState(isEnabled)
    }
    
    private func updateInputBarPhotosButtonState(_ isEnabled: Bool) {
        inputBarStateDelegate?.setPhotosButtonState(isEnabled)
    }
    
    private func updateTagMessageSelectedState(_ selectedTags: [Tag]) {
        messageStorageDelegate?.updateTagMessage(selectedTags: selectedTags)
    }
    
    private func updateInputTextViewState(isEditable: Bool) {
        inputBarStateDelegate?.updateInputTextViewState(isEditable)
    }
    
    private func compressImage(
        _ data: [Data],
        completion: @escaping ([Data]) -> Void)
    {
        let group = DispatchGroup()
        var compressedData: [Data] = []
        
        data.forEach {
            group.enter()
            ImageCompressor.compress(imageData: $0) { compressedImage in
                guard let data = compressedImage else { return }
                compressedData.append(data)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(compressedData)
        }
    }
    
    private func handlePhotoUploads(with data: [Data]) {
        let totalPhotosToUpload = data.count
        var photoUploadCount = 0
        
        data.forEach {
            let photoMessage = createPhotoMessage(from: $0)
            photoUploadCount += 1
            insertMessage(photoMessage)
        }

        if totalPhotosToUpload == photoUploadCount {
            updateImageUploadButtonState(false)
            updateInputBarPhotosButtonState(false)
            extractKeywords(from: data)
        }
    }
    
    private func extractKeywords(from imageData: [Data]) {
        insertLoadingMessage()
        let group = DispatchGroup()
        
        imageData.forEach {
            let base64String = $0.base64EncodedString()
            group.enter()
            fetchKeywordsFromGoogleVision(base64String: base64String) {
                group.leave()
            }
            
            group.enter()
            fetchLandMarksFromGoogleVision(base64String: base64String) {
                group.leave()
            }
        }
        
        group.notify(queue: .global(qos: .userInteractive)) { [weak self] in
            guard let self else { return }
            
            self.visionResultProcessor.getFourMostConfidentTranslatedTags() { [weak self] in
                guard let self else { return }
                let defaultTags = self.makeDefaultTags()
                let appendedTags = defaultTags + $0
                let tagMessage = self.createTagMessage(from: appendedTags)
                
                removeLoadingMessage()
                insertMessage(tagMessage)
            }
        }
    }
    
    private func makeDefaultTags() -> [Tag] {
        let locationTags = ["국내", "해외"].map { Tag(category: .location, value: $0) }
        let themeTags = ["관광", "휴양", "음식", "역사탐방", "액티비티"].map { Tag(category: .theme, value: $0) }
        
        return locationTags + themeTags
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
    
    // MARK: Message
    
    private func createTextMessage(with text: String, sender: Sender) -> Message {
        let messageText = NSMutableAttributedString()
            .messageText(text, font: .bodyRegular, sender: sender)
        return Message(
            text: messageText,
            sender: sender,
            sentDate: Date())
    }
    
    private func createPhotoMessage(from imageData: Data) -> Message {
        return Message(
            imageData: imageData,
            sender: user,
            sentDate: Date())
    }
    
    private func createTagMessage(from tags: [Tag]) -> Message {
        return Message(tags: tags)
    }
    
    private func insertRecommendationMessage(with result: OpenAIRecommendation) {
        insertLoadingMessage()
        
        let items = result.recommendationItems
        let group = DispatchGroup()
        var currentRecommendations: [RecommendationItem] = []
        
        for item in items {
            group.enter()
            createRecommendationItem(with: item) { recommendationItem in
                currentRecommendations.append(recommendationItem)
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            let message = Message(recommendations: currentRecommendations)
            removeLoadingMessage()
            insertMessage(message)
            insertAdditionalQuestionMessage()
            self.recommendationItems.append(contentsOf: currentRecommendations)
        }
    }
    
    private func createRecommendationItem(
        with item: OpenAIRecommendation.RecommendationItem,
        completion: @escaping ((RecommendationItem) -> Void))
    {
        imageSearchUseCase.searchImage(with: selectedTags, item: item) { result in
            switch result {
            case .success(let imageData):
                let recommendationItem = RecommendationItem(
                    country: item.country,
                    spotKorean: item.spotKorean,
                    spotEnglish: item.spotEnglish,
                    image: imageData)
                completion(recommendationItem)
            case .failure:
                let recommendationItem = RecommendationItem(
                    country: item.country,
                    spotKorean: item.spotKorean,
                    spotEnglish: item.spotEnglish,
                    image: Data())
                completion(recommendationItem)
            }
        }
    }
    
    private func insertLoadingMessage() {
        let loadingMessage = createLoadingMessage()
        insertMessage(loadingMessage)
        updateInputTextViewState(isEditable: false)
    }
    
    private func removeLoadingMessage() {
        messageStorageDelegate?.removeLoadingMessage()
        updateInputTextViewState(isEditable: true)
    }
    
    private func createLoadingMessage() -> Message {
        return Message(sender: ai, messageId: "loading", sentDate: Date())
    }
    
    private func insertAdditionalQuestionMessage() {
        let additionalQuestionTextMessage = createTextMessage(with: "더 궁금한 점이 있으신가요?", sender: ai)
        
        insertMessage(additionalQuestionTextMessage)
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
        insertLoadingMessage()
        openAIChatMessages.append(message)
        openAIUseCase.send(chatMessages: openAIChatMessages) { [weak self] result in
            guard let self else { return }
            
            self.removeLoadingMessage()
            
            switch result {
            case .success(let chatMessages):
                self.openAIChatMessages.append(contentsOf: chatMessages)
                self.configureOpenAIResponse(chatMessages)
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
        // TODO: - 디코딩 로직 Repository로 옮기기
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
        updateTagMessageSelectedState(selectedTags)
        buttonStateDelegate?.setTagMessageInteractionState(submitButtonState: false, interactionState: false)
        
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
        clearInputText(from: inputBar)
    }
    
    private func clearInputText(from inputBar: InputBarAccessoryView) {
        inputBar.inputTextView.text = String()
    }
}

extension ChatViewModel: ImagePickerDelegate {
    func photoDataSent(_ data: [Data]) {
        compressImage(data) { [weak self] data in
            self?.handlePhotoUploads(with: data)
        }
    }
}

// MARK: Constant

private extension ChatViewModel {
    
    enum Constant {
        static let welcomeText = "오늘은 어디로 여행을 떠나고 싶나요? 사진을 보내주시면 원하는 분위기의 여행지를 추천해드릴게요!"
        
        static let openAISystemPrompt: String = """
            당신은 사용자가 입력한 키워드에 기반해서 3개의 여행지를 추천해주는 챗봇입니다. 차근차근 생각해 봅시다.

            step 1. 사용자가 최소 2개 이상의 키워드를 선택합니다. "국내" 또는 "해외" 키워드가 주어진 경우, "국내"는 한국을, "해외"가 있다면 해외는 한국 외 국가를 의미합니다.
            step 2. 여행 주제의 문서나 데이터베이스에서 해당 키워드와 관련된 여행지를 검색합니다. 검색된 여행지를 키워드와의 유사도를 기준으로 오름차순으로 정렬한 후 상위 세 곳의 여행지를 선별합니다.
            step 3. 여행지 정보는 JSON 형식으로 반환합니다. JSON 응답의 구조는 다음과 같습니다. recommendationItems라는 배열 안에 각각의 여행지 정보를 포함합니다. 각 여행지 정보에는 "country" (한국어 국가 이름), "spotKorean" (여행지 이름 국문), "spotEnglish" (여행지 이름 영문)을 할당합니다.

            예시:
            ```
            {
              "recommendationItems": [
                {
                  "country": "한국",
                  "spotKorean": "제주도 한라산",
                  "spotEnglish": "Hallasan"
                },
                {
                  "country": "일본",
                  "spotKorean": "고베 누노비키 허브원",
                  "spotEnglish": "Nunobiki Herb Garden"
                },
                {
                  "country": "이탈리아",
                  "spotKorean": "로마 콜로세움",
                  "spotEnglish": "Colosseum"
                }
              ]
            }

            step 4. 이후 사용자가 추가로 여행지 정보를 요청하는 경우, 최초 제공한 여행지 정보 이외의 여행지 정보를 JSON 형식으로 반환합니다. 그러나 사용자가 여행지 관련 정보를 질문하는 경우, 텍스트 형식으로 답변을 제공합니다. 이때 여행지 관련 정보는 출처가 분명하며 사실에 기반한 것이어야 합니다.
            """
    }
}
