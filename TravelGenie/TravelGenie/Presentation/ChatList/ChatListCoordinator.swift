//
//  ChatListCoordinator.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import UIKit

final class ChatListCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinationFinishDelegate?
    weak var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    
    // MARK: Lifecycle
    
    init(finishDelegate: CoordinationFinishDelegate, navigationController: UINavigationController?) {
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ChatListViewModel(
            chatUseCase: DefaultChatUseCase(
                chatRepository: DefaultChatRepository()))
        let chatListViewController = ChatListViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController?.pushViewController(chatListViewController, animated: false)
    }
        
    func chatHistoryFlow(chat: Chat) {
        let chatHistoryCoordinator = ChatHistoryCoordinator(finishDelegate: self, navigationController: navigationController)
        childCoordinators.append(chatHistoryCoordinator)
        chatHistoryCoordinator.chat = chat
        chatHistoryCoordinator.start()
    }
}

extension ChatListCoordinator: CoordinationFinishDelegate { }
