//
//  HomeViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/14.
//

import Foundation

final class HomeViewModel {
    
    weak var coordinator: HomeCoordinator?
    var bottomMenuCellTapped: ((URL?) -> Void)?
    
    let bottomMenus: [BottomMenuItem] = [
        BottomMenuItem(type: .termsOfService),
        BottomMenuItem(type: .privacyPolicy),
        BottomMenuItem(type: .inquiries),
    ]
    
    func didTapNewChatButton() {
        coordinator?.newChatFlow()
    }
    
    func didTapChatListButton() {
        coordinator?.chatListFlow()
    }
    
    func didTapBottomMenuCell(at row: Int) {
        let selectedMenu = bottomMenus[row]
        let url = URL(string: selectedMenu.url)

        bottomMenuCellTapped?(url)
    }
}
