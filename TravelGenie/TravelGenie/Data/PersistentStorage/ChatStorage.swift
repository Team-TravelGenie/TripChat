//
//  ChatStorage.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/22.
//

import Foundation

protocol ChatStorage {
    func saveChat(
        _ chat: Chat,
        completion: @escaping (Result<Chat, Error>) -> Void)
}
