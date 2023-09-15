//
//  ChatInterfaceViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/28.
//

final class ChatInterfaceViewModel {
    
    let messageStorage: MessageStorage = MessageStorage()
    var didChangeMessageList: (() -> Void)?
    var disabledUploadButtonState: (() -> Void)?
    var didChangeTagMessageInteractionState: (() -> Void)?
    
    private (set) var uploadButtonState: Bool = true {
        didSet {
            disabledUploadButtonState?()
        }
    }
    
    private (set) var tagMessageInteractionState = TagMessageInteractionState() {
        didSet {
            didChangeTagMessageInteractionState?()
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

    func updateTagMessage(selectedTags: [Tag]) {
        messageStorage.updateTagMessage(selectedTags)
    
    func removeLoadingMessage() {
        messageStorage.removeLoadingMessage()
    }
}

// MARK: ButtonStateDelegate

extension ChatInterfaceViewModel: ButtonStateDelegate {
    
    func setUploadButtonState(_ isEnabled: Bool) {
        uploadButtonState = isEnabled
    }
    
    func setTagMessageInteractionState(submitButtonState: Bool, interactionState: Bool) {
        let state = TagMessageInteractionState(submitButtonState: submitButtonState, interactionState: interactionState)
        
        tagMessageInteractionState = state
    }
}
