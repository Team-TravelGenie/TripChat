//
//  ChatListViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import Foundation

final class ChatListViewModel {
    
    weak var coordinator: ChatListCoordinator?
    
    private let chatUseCase: ChatUseCase
    
    private(set) var chats: [Chat] = []
    
    // MARK: Lifecycle
    
    init(chatUseCase: ChatUseCase) {
        self.chatUseCase = chatUseCase
        addChat()
    }
    
    // MARK: Internal
    func deleteItem(at row: Int) {
        
    }
    
    // MARK: Private
    
    private func addChat() {
        let chat1 = Chat(id: UUID(), createdAt: Date(), tags: ["바다", "동남아", "휴양지"], recommendations: [], messages: [])
        let chat2 = Chat(id: UUID(), createdAt: Date(), tags: ["바다다", "동남아", "휴양지"], recommendations: [], messages: [])
        let chat3 = Chat(id: UUID(), createdAt: Date(), tags: ["바다다다", "동남아", "휴양지"], recommendations: [], messages: [])
        self.chats.append(chat1)
        self.chats.append(chat2)
        self.chats.append(chat3)
    }
}
