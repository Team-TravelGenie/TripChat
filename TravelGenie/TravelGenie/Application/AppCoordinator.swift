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
    
    init(window: UIWindow?, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

extension AppCoordinator: CoordinationFinishDelegate { }
