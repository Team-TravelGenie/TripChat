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
        BottomMenuItem(type: .termsOfService),
        BottomMenuItem(type: .privacyPolicy),
    ]
    
    func didTapNewChatButton() {
        coordinator?.newChatFlow()
    }
    
    func didTapChatListButton() {
        coordinator?.chatListFlow()
    }
    
    // TODO: 코디네이터 패턴 적용으로 변경
    func didTapBottomMenuCell(at row: Int) {
        showBottomMenu?(bottomMenus[row])
    }
}
