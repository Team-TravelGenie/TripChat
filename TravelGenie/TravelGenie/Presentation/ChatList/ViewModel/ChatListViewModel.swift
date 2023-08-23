//
//  ChatListViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import Foundation

final class ChatListViewModel {
    
    weak var coordinator: ChatListCoordinator?
    
    private let chatUseCase: ChatUseCase
    
    private(set) var chats: [Chat] = []
    
    // MARK: Lifecycle
    
    init(chatUseCase: ChatUseCase) {
        self.chatUseCase = chatUseCase
        addChat()
    }
    
    // MARK: Internal
    func deleteItem(at index: Int) {
        let id = chats[index].id
        chatUseCase.deleteChat(with: id) { [weak self] result in
            switch result {
            case .success:
                self?.chats.remove(at: index)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: Private
    
    private func addChat() {
    }
}
