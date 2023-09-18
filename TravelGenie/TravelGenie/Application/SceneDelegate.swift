//
//  SceneDelegate.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            let rootViewController = UINavigationController()
            self?.coordinator = AppCoordinator(window: window, navigationController: rootViewController)
            self?.coordinator?.start()
        }
    }
}
