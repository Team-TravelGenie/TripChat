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
        fetchRecentChat()
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
    
    private func addChat() {
        let tagItem = TagItem(tags: [Tag(category: .theme, value: "22바다"), Tag(category: .theme, value: "동남아")])
        let recommendationItem = RecommendationItem(country: "나라", city: "도시", spot: "장소", image: .init())
        let chat1 = Chat(id: UUID(), createdAt: Date(), tags: tagItem, recommendations: [], messages: [])
        let chat2 = Chat(id: UUID(), createdAt: Date(), tags: tagItem, recommendations: [recommendationItem], messages: [])

        chatUseCase.save(chat: chat1) { _ in }
        chatUseCase.save(chat: chat2) { _ in }
    }
}
