//
//  ChatHistoryViewModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/04.
//

import Foundation

final class ChatHistoryViewModel {
    
    weak var coordinator: ChatHistoryCoordinator?
    
    var chat: Chat
    
    init(chat: Chat) {
        self.chat = chat
        print(chat)
    }
    
}
