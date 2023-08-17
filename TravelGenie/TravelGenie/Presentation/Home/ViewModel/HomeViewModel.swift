//
//  HomeViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/14.
//

import Foundation

final class HomeViewModel {
    
    weak var coordinator: HomeCoordinator?
    
    func didTapNewChatButton() {
        coordinator?.newChatFlow()
    }
    
    func didTapChatListButton() {
        coordinator?.chatListFlow()
    }
}
