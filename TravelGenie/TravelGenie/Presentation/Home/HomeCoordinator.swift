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
        let backBarButtonItem = UIBarButtonItem(title: String(), style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        homeViewModel.coordinator = self
        homeViewController.navigationItem.backBarButtonItem = backBarButtonItem
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func newChatFlow() {
        let chatCoordinator = ChatCoordinator(finishDelegate: self, navigationController: navigationController)
        childCoordinators.append(chatCoordinator)
        chatCoordinator.start()
    }
    
    func chatListFlow() {
        let chatListCoordinator = ChatListCoordinator(finishDelegate: self, navigationController: navigationController)
        childCoordinators.append(chatListCoordinator)
        chatListCoordinator.start()
    }
}

extension HomeCoordinator: CoordinationFinishDelegate { }
