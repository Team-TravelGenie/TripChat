//
//  HomeViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/14.
//

import Foundation

final class HomeViewModel {
    
    weak var coordinator: HomeCoordinator?
    var externalLinkCellTapped: ((URL?) -> Void)?
    var copyLinkCellTapped: ((String) -> Void)?
    
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
        
        switch selectedMenu.type {
        case .termsOfService, .privacyPolicy:
            let url = URL(string: selectedMenu.url)
            externalLinkCellTapped?(url)
        case .inquiries:
            let emailAddress: String = selectedMenu.url
            copyLinkCellTapped?(emailAddress)
        }
    }
}
