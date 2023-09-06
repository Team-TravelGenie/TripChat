//
//  ChatListViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import Foundation

final class ChatListViewModel {
    
    weak var coordinator: ChatListCoordinator?
    
    var emptyChat: ((Bool) -> Void)?
    var chatsDelivered: (([Chat]) -> Void)?
    
    private let chatUseCase: ChatUseCase
    private(set) var chats: [Chat] = [] {
        didSet {
            emptyChat?(chats.isEmpty)
            chatsDelivered?(chats)
        }
    }
    
    // MARK: Lifecycle
    
    init(chatUseCase: ChatUseCase) {
        self.chatUseCase = chatUseCase
        fetchRecentChat()
    }
    
    // MARK: Internal
    
    func remove(at index: Int) {
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
    
    func fireSearch(with keyword: String?) {
        guard let keyword else { return }
        chatUseCase.fetchChats(with: keyword) { [weak self] result in
            switch result {
            case .success(let chats):
                self?.chats = chats
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didSelectChat(index: Int) {
        let chat = chats[index]
        
        coordinator?.chatHistoryFlow(chat: chat)
    }
    
    // MARK: Private
    
    private func fetchRecentChat() {
        chatUseCase.fetchRecentChats(pageSize: 20) { [weak self] result in
            switch result {
            case .success(let fetchedChats):
                self?.chats.append(contentsOf: fetchedChats)
            case .failure(let error):
                print(error)
            }
        }
    }
}
