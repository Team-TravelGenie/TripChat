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
    }
}
