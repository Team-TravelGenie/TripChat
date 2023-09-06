//
//  ChatInterfaceViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/28.
//

final class ChatInterfaceViewModel {
    
    let messageStorage: MessageStorage = MessageStorage()
    var didchangeUploadButtonState: ((Bool) -> Void)?
    var didchangeTagCellButtonState: ((Bool) -> Void)?
    
    private (set) var uploadButtonState: Bool = true {
        didSet {
            didchangeUploadButtonState?(uploadButtonState)
        }
    }
    
    private (set) var tagCellButtonState: Bool = true {
        didSet {
            didchangeTagCellButtonState?(tagCellButtonState)
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
    
    func setTagCellButtonState(_ isEnabled: Bool) {
        tagCellButtonState = isEnabled
    }
}
