//
//  ChatViewModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import UIKit

protocol MessageStorageDelegate: AnyObject {
    func insert(message: Message)
}

final class ChatViewModel {
    
    weak var coordinator: ChatCoordinator?
    weak var delegate: MessageStorageDelegate?
    
    private let user: Sender = Sender(name: .user)
    
    // MARK: Internal
    
    func insertMessage(_ message: Message) {
        delegate?.insert(message: message)
    }
    
    func makePhotoMessage(_ image: UIImage) {
        let message = Message(
            image: image,
            sender: self.user,
            sentDate: Date())
        delegate?.insert(message: message)
    }
    
    func backButtonTapped() -> (viewModel: PopUpViewModel, type: PopUpContentView.PopUpType) {
        let popUpViewModel = createPopUpViewModel()
        let popUpModel = createPopUpModel()
        
        return (viewModel: popUpViewModel, type: .normal(popUpModel))
    }
    
    func pop() {
        coordinator?.finish()
    }
    
    private func requestRecommendations(with tags: [Tag]) {
        let keywords: [String] = tags.map { $0.value }
        
        // TODO: - ChatGPT에 keyword 넣어서 요청 보내기
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

    }
}
