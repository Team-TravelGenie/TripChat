//
//  CoreDataChatStorage.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/22.
//

import Foundation

final class CoreDataChatStorage: ChatStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage) {
        self.coreDataStorage = coreDataStorage
    }
    
    func saveChat(_ chat: Chat) {
        coreDataStorage.create(chat)
    }
}
