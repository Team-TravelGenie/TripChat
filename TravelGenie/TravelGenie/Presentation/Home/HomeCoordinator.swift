//
//  HomeCoordinator.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/15.
//

import UIKit

final class HomeCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate?
    var navigationController: UINavigationController
    
    // MARK: Lifecycle
    
    init(finishDelegate: CoordinationFinishDelegate, navigationController: UINavigationController) {
        self.finishDelegate = finishDelegate
        self.navigationController = navigationController
    }
    
    // MARK: Internal
    
    func start() {
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        homeViewModel.coordinator = self
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func newChatFlow() {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController)
        childCoordinators.append(chatCoordinator)
        chatCoordinator.start()
    }
    
    func chatListFlow() {
        // TODO: - ChatList Coordinator 생성, childCoordinators에 append, coordinator.start() 호출
    }
}
