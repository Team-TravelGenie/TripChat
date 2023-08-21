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
        addChat()
    }
    
    // MARK: Internal
    func deleteItem(at row: Int) {
        
    }
    
    // MARK: Private
    
    private func addChat() {
        let chat1 = Chat(date: Date(), tags: ["바다", "동남아", "휴양지"])
        let chat2 = Chat(date: Date(), tags: ["바다다", "동남아", "휴양지"])
        let chat3 = Chat(date: Date(), tags: ["바다다다", "동남아", "휴양지"])
        self.chats.append(chat1)
        self.chats.append(chat2)
        self.chats.append(chat3)
    }
}
