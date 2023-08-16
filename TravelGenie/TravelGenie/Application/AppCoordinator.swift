//
//  AppCoordinator.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/15.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var window: UIWindow?
    var childCoordinators : [Coordinator] = []
    var finishDelegate: CoordinationFinishDelegate? = nil
    var navigationController: UINavigationController
    
    // MARK: Lifecycle
    
    init(window: UIWindow?, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    // MARK: Internal
    
    func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        homeFlow(navigationController: navigationController)
    }
    
    // MARK: Private
    
    private func homeFlow(navigationController: UINavigationController) {
        let homeCoordinator = HomeCoordinator(finishDelegate: self, navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}

// MARK: - AppCoordinator + CoordinationFinishDelegate

extension AppCoordinator: CoordinationFinishDelegate { }
