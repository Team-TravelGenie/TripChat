//
//  ChatRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//

import Foundation

protocol ChatRepository {
    func saveChat(_ chat: Chat)
    func fetchChatList() -> [Chat]
    func fetchChatList(with keyword: String) -> [Chat]
    func delete(_ chat: Chat)
}
