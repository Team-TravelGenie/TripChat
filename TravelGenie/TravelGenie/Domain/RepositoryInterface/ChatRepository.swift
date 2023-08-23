//
//  ChatRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//

import Foundation

protocol ChatRepository {
    func save(
        chat: Chat,
        completion: @escaping (Result<Chat, Error>) -> Void)
    func fetchRecentChats(
        pageSize: Int,
        completion: @escaping (Result<[Chat], Error>) -> Void)
    func fetchChats(
        with keyword: String,
        completion: @escaping (Result<[Chat], Error>) -> Void)
    func delete(_ chat: Chat)
}
