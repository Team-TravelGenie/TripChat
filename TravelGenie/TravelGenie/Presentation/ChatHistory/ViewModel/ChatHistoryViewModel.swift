//
//  ChatHistoryViewModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/04.
//

import Foundation

final class ChatHistoryViewModel {
    
    weak var coordinator: ChatHistoryCoordinator?
    weak var delegate: MessageStorageDelegate?
    weak var buttonStateDelegate: ButtonStateDelegate?
    
    var chat: Chat
    
    init(chat: Chat) {
        self.chat = chat
    }
    
    func insertChatMessages() {
        chat.messages.forEach { delegate?.insert(message: $0) }
    }
    
    func deactivateButtons() {
        buttonStateDelegate?.setUploadButtonState(false)
    }
    
}
