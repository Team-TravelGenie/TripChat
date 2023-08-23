//
//  DefaultChatRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//

import Foundation

final class DefaultChatRepository: ChatRepository {
    
    private let chatStorage: ChatStorage
    
    init(chatStorage: ChatStorage = CoreDataStorage.shared) {
        self.chatStorage = chatStorage
    }
    
    func saveChat(
        _ chat: Chat,
        completion: @escaping (Result<Chat, Error>) -> Void) {
        chatStorage.saveChat(chat, completion: completion)
    }
    
    func fetchChatList() -> [Chat] {
        
        return []
    }
    
    func fetchChatList(with keyword: String) -> [Chat] {
        
        return []
    }
    
    func delete(_ chat: Chat) {
        
    }
}
