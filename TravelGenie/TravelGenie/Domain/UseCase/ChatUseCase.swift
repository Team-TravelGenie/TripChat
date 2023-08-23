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
}
