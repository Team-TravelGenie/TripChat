//
//  ChatCoordinator.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/18.
//

import UIKit

final class ChatCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinationFinishDelegate?
    weak var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    
    init(finishDelegate: CoordinationFinishDelegate, navigationController: UINavigationController?) {
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
    }
    
    func start() {
        let chatViewModel = ChatViewModel(
            chatUseCase: DefaultChatUseCase(
                chatRepository: DefaultChatRepository()))
        let chatViewController = ChatViewController(viewModel: chatViewModel)
        chatViewModel.coordinator = self
        navigationController?.pushViewController(chatViewController, animated: false)
    }
}
