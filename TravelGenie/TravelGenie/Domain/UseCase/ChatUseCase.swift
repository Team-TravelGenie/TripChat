//
//  ChatUseCase.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//

import Foundation

protocol ChatUseCase {
    func saveChat(_ chat: Chat)
}

final class DefaultChatUseCase: ChatUseCase {
    
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    func saveChat(_ chat: Chat) {
        chatRepository.saveChat(chat)
    }
}
