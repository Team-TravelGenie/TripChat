//
//  ChatInterfaceViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/28.
//

final class ChatInterfaceViewModel {
    
    let messageStorage: MessageStorage = MessageStorage()
    var didChangeMessageList: (() -> Void)?
    var didChangeUploadButtonState: ((Bool) -> Void)?
    var didChangeTagCellButtonState: ((Bool) -> Void)?
    
    private (set) var uploadButtonState: Bool = true {
        didSet {
            didChangeUploadButtonState?(uploadButtonState)
        }
    }
    
    private (set) var tagCellButtonState: Bool = true {
        didSet {
            didChangeTagCellButtonState?(tagCellButtonState)
        }
    }
    
    // MARK: Lifecycle
    
    init() {
        bind()
    }
    
    // MARK: Private
    
    private func bind() {
        messageStorage.didChangeMessageList = { [weak self] in
            self?.didChangeMessageList?()
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
