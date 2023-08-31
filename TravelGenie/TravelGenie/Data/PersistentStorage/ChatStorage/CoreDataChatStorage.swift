//
//  CoreDataChatStorage.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/31.
//

import Foundation

final class CoreDataChatStorage {
    
}

extension CoreDataChatStorage: ChatStorage {
    
    // MARK: Internal
    
    func save(
        chat: Chat,
        completion: @escaping (Result<Chat, Error>) -> Void)
    {
    
    func fetchRecentChats(pageSize: Int, completion: @escaping (Result<[Chat], Error>) -> Void) {
        
    }
    
    func fetchChats(
        with keyword: String,
        completion: @escaping (Result<[Chat], Error>) -> Void)
    {
    }
    
    func deleteChat(with id: UUID, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
}
