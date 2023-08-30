//
//  ChatInterfaceViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/28.
//

final class ChatInterfaceViewModel {
    
    let messageStorage: MessageStorage = MessageStorage()
}

// MARK: MessageStorageDelegate

extension ChatInterfaceViewModel: MessageStorageDelegate {
    func insert(message: Message) {
        messageStorage.insertMessage(message)
    }
    
    func fetchMessages() -> [Message] {
        return messageStorage.fetchMessages()
    }
}
