//
//  CoordinationFinishDelegate.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/15.
//

import Foundation

protocol CoordinationFinishDelegate: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    
    func didFinish(child: Coordinator)
}

extension CoordinationFinishDelegate {
    func didFinish(child: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
}
