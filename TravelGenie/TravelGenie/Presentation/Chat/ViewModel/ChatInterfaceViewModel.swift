//
//  ChatInterfaceViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/28.
//

final class ChatInterfaceViewModel {
    
    let messageStorage: MessageStorage = MessageStorage()
    var didchangeUploadButtonState: ((Bool) -> Void)?
    
    private (set) var uploadButtonState: Bool = true {
        didSet {
            didchangeUploadButtonState?(uploadButtonState)
        }
    }
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

// MARK: ButtonStateDelegate

extension ChatInterfaceViewModel: ButtonStateDelegate {
    func setUploadButtonState(_ isEnabled: Bool) {
        uploadButtonState = isEnabled
    }
}
