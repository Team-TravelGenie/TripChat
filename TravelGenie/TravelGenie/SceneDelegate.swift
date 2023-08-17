//
//  SceneDelegate.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let chatVC = ChatViewController(viewModel: ChatViewModel())
        window.rootViewController = UINavigationController(rootViewController: chatVC)
        window.makeKeyAndVisible()
        self.window = window
    }
}
