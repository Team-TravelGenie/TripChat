//
//  HomeViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/14.
//

import Foundation

final class HomeViewModel {
    
    weak var coordinator: HomeCoordinator?
    var showBottomMenu: ((BottomMenuItem) -> Void)?
    
    var bottomMenus: [BottomMenuItem] = [
        BottomMenuItem(title: "서비스 이용약관", description: ""),
        BottomMenuItem(title: "개인정보처리방침", description: ""),
    ]
    
    func didTapNewChatButton() {
        coordinator?.newChatFlow()
    }
    
    func didTapChatListButton() {
        coordinator?.chatListFlow()
    }
    
    func didTapBottomMenuCell(at row: Int) {
        showBottomMenu?(bottomMenus[row])
    }
}
