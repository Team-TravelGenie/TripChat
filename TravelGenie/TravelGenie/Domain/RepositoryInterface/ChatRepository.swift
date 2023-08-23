//
//  ChatRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//

import Foundation

protocol ChatRepository {
    func fetchChatList() -> [Chat]
    func fetchChatList(with keyword: String) -> [Chat]
    func saveChat(
        _ chat: Chat,
        completion: @escaping (Result<Chat, Error>) -> Void)
    func delete(_ chat: Chat)
}
