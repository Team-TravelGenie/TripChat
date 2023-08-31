//
//  CoreDataChatStorage.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/31.
//

import Foundation

final class CoreDataChatStorage {
    
    private let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService = CoreDataService.shared) {
        self.coreDataService = coreDataService
    }
}

extension CoreDataChatStorage: ChatStorage {
    
    // MARK: Internal
    
    func save(
        chat: Chat,
        completion: @escaping (Result<Chat, Error>) -> Void)
    {
    
    func fetchRecentChats(pageSize: Int, completion: @escaping (Result<[Chat], Error>) -> Void) {
        
    }
    
    func fetchChats(
        with keyword: String,
        completion: @escaping (Result<[Chat], Error>) -> Void)
    {
        let tagResult: [Chat] = fetchWithTag(keyword)
        let recommendationResult: [Chat] = fetchWithRecommendation(keyword)
        let result: [Chat] = tagResult + recommendationResult
        
        if result.isEmpty {
            completion(.failure(StorageError.noResultForKeyword))
        } else {
            completion(.success(result))
        }
    }
    
    func deleteChat(with id: UUID, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    // MARK: Private
    
    private func fetchWithTag(_ tag: String) -> [Chat] {
        var result: [Chat] = []
        let request = TagEntity.fetchRequest()
        let predicate = NSPredicate(format: "value CONTAINS[c] %@", tag)
        
        do {
            let tagEntities: [TagEntity] = try coreDataService.fetch(request: request, predicate: predicate)
            tagEntities.forEach {
                if let chatEntities = $0.chat?.array as? [ChatEntity] {
                    result.append(contentsOf: chatEntities.map { $0.toDomain() })
                }
            }
            
            return result
        } catch {
            return result
        }
    }
    
    private func fetchWithRecommendation(_ keyword: String) -> [Chat] {
        var result: [Chat] = []
        let request = RecommendationEntity.fetchRequest()
        let countryPredicate = NSPredicate(format: "country CONTAINS[c] %@", keyword)
        let spotPredicate = NSPredicate(format: "spot CONTAINS[c] %@", keyword)
        let predicate = NSCompoundPredicate(
            type: .or,
            subpredicates: [
                countryPredicate,
                spotPredicate,
            ])
        
        do {
            let recommendationEntities: [RecommendationEntity] = try coreDataService.fetch(request: request, predicate: predicate)
            recommendationEntities.forEach {
                if let chatEntities = $0.chat?.array as? [ChatEntity] {
                    result.append(contentsOf: chatEntities.map { $0.toDomain()} )
                }
            }
            
            return result
        } catch {
            return result
        }
    }
}
