//
//  ChatCoordinator.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/18.
//

import UIKit

final class ChatCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate?
    var navigationController: UINavigationController
    
    init(finishDelegate: CoordinationFinishDelegate? = nil, navigationController: UINavigationController) {
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
    }
    
    func start() {
        let chatViewModel = ChatViewModel()
        let chatViewController = ChatViewController(viewModel: chatViewModel)
        chatViewModel.coordinator = self
        navigationController.pushViewController(chatViewController, animated: false)
    }
}
