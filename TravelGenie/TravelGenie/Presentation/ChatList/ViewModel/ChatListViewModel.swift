//
//  ChatListViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import Foundation

final class ChatListViewModel {
    
    weak var coordinator: ChatListCoordinator?
    
    private(set) var chats: [Chat]
    
    // MARK: Lifecycle
    
    init(chats: [Chat]) {
        self.chats = chats
    // MARK: Internal
    func deleteItem(at row: Int) {
        
    }
    }
}
