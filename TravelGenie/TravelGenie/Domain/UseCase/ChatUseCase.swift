//
//  ChatUseCase.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//

import Foundation

protocol ChatUseCase {
    func saveChat(
        _ chat: Chat,
        completion: @escaping (Result<Chat, Error>) -> Void)
    func fetchRecentChats(
        pageSize: Int,
        completion: @escaping (Result<[Chat], Error>) -> Void)
    func fetchChats(
        with keyword: String,
        completion: @escaping (Result<[Chat], Error>) -> Void)
}

final class DefaultChatUseCase: ChatUseCase {
    
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    func saveChat(
        _ chat: Chat,
        completion: @escaping (Result<Chat, Error>) -> Void)
    {
        chatRepository.saveChat(chat, completion: completion)
    }
    
    func fetchRecentChats(
        pageSize: Int,
        completion: @escaping (Result<[Chat], Error>) -> Void)
    {
        chatRepository.fetchRecentChats(pageSize: pageSize, completion: completion)
    }
    
    func fetchChats(
        with keyword: String,
        completion: @escaping (Result<[Chat], Error>) -> Void)
    {
        chatRepository.fetchChats(with: keyword) { result in
            switch result {
            case .success(let chats):
                let sortedChats = chats.sorted { $0.createdAt > $1.createdAt }
                completion(.success(sortedChats))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
