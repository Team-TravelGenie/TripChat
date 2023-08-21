//
//  ChatListCoordinator.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import UIKit

final class ChatListCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate?
    var navigationController: UINavigationController
    
    // MARK: Lifecycle
    
    init(finishDelegate: CoordinationFinishDelegate, navigationController: UINavigationController) {
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
    }
    
    func start() {
        // TODO: - 뷰모델에 저장소 주입
        let viewModel = ChatListViewModel(chats: .init())
        let chatListViewController = ChatListViewController(viewModel: viewModel)
        viewModel.coordinator = self
        navigationController.pushViewController(chatListViewController, animated: false)
    }
}
