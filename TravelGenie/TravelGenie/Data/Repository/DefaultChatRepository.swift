//
//  DefaultChatRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//

import Foundation

final class DefaultChatRepository: ChatRepository {
    
    private let chatStorage: ChatStorage
    
    init(chatStorage: ChatStorage = CoreDataChatStorage()) {
        self.chatStorage = chatStorage
    }
    
    func save(
        chat: Chat,
        completion: @escaping (Error?) -> Void)
    {
        chatStorage.save(chat: chat, completion: completion)
    }
    
    func fetchRecentChats(
        pageSize: Int,
        completion: @escaping (Result<[Chat], Error>) -> Void)
    {
        chatStorage.fetchRecentChats(pageSize: pageSize, completion: completion)
    }
    
    func fetchChats(
        with keyword: String,
        completion: @escaping (Result<[Chat], Error>) -> Void)
    {
        chatStorage.fetchChats(with: keyword, completion: completion)
    }
    
    func deleteChat(with id: UUID, completion: @escaping (Error?) -> Void) {
        chatStorage.deleteChat(with: id, completion: completion)
    }
}
