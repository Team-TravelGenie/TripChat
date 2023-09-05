//
//  ChatHistoryCoordinator.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/04.
//

import UIKit

final class ChatHistoryCoordinator: Coordinator {
    
    var finishDelegate: CoordinationFinishDelegate?
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    
    private let chat: Chat
    
    // MARK: Lifecycle
    
    init(finishDelegate: CoordinationFinishDelegate, navigationController: UINavigationController?, chat: Chat) {
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
        self.chat = chat
    }
    
    func start() {
        let chatHistoryViewModel = ChatHistoryViewModel(chat: chat)
        let chatHistoryViewController = ChatHistoryViewController(historyViewModel: chatHistoryViewModel)
        chatHistoryViewModel.coordinator = self
        navigationController?.pushViewController(chatHistoryViewController, animated: false)
    }
}
