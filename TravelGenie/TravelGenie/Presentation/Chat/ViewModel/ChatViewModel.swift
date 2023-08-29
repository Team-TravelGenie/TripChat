//
//  ChatViewModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

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
    
    private func requestRecommendations(with tags: [Tag]) {
        let keywords: [String] = tags.map { $0.value }
        // TODO: - ChatGPT에 keyword 넣어서 요청 보내기
    private func insertMessage(_ message: Message) {
        delegate?.insert(message: message)
    }
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
        requestRecommendations(with: selectedTags)
    }
}
