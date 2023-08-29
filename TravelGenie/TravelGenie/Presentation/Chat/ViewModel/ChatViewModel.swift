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
}

final class ChatViewModel {
    
    weak var coordinator: ChatCoordinator?
    weak var delegate: MessageStorageDelegate?
    var didTapImageUploadButton: (() -> Void)?
    
    private let user: Sender = Sender(name: .user)
    private let openAIUseCase: OpenAIUseCase
    private var openAIChatMessages: [ChatMessage] = []
    
    // MARK: Lifecycle
    
    init(openAIUseCase: OpenAIUseCase) {
        self.openAIUseCase = openAIUseCase
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
            sender: self.user,
            sentDate: Date())
        insertMessage(message)
    }
    
    func backButtonTapped() -> (viewModel: PopUpViewModel, type: PopUpContentView.PopUpType) {
        let popUpViewModel = createPopUpViewModel()
        let popUpModel = createPopUpModel()
        
        return (viewModel: popUpViewModel, type: .normal(popUpModel))
    }
    
    func pop() {
        coordinator?.finish()
    }
    
    // MARK: Private
    
    private func insertMessage(_ message: Message) {
        delegate?.insert(message: message)
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
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func createTextMessage(with text: String) -> Message {
        let messageText = NSMutableAttributedString()
            .text(text, font: .bodyRegular, color: .black)
        return Message(
            text: messageText,
            sender: Sender(name: .ai),
            sentDate: Date())
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
    
    // MARK: objc methods
    
    @objc private func didTapImageUploadButton(notification: Notification) {
        didTapImageUploadButton?()
    }

    @objc private func submitSelectedTags(notification: Notification) {
        guard let selectedTags = notification.userInfo?[NotificationKey.selectedTags] as? [Tag] else { return }
        
        let tagText = selectedTags.map { $0.value }.joined(separator: ", ")
        let selectedTagTextMessage = createTextMessage(with: tagText)
        insertMessage(selectedTagTextMessage)
        sendSelectedTags(tagText)
    }
}

// MARK: InputBarAccessoryViewDelegate

extension ChatViewModel: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let textMessage = createTextMessage(with: text)
        let openAIChatMessage = ChatMessage(role: .user, content: text)
        insertMessage(textMessage)
        sendMessageToOpenAI(openAIChatMessage)
    }
}
