//
//  Coordinator.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/14.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var finishDelegate: CoordinationFinishDelegate? { get }
    var navigationController: UINavigationController? { get set }
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.didFinish(child: self)
        navigationController?.popViewController(animated: false)
    }
}
