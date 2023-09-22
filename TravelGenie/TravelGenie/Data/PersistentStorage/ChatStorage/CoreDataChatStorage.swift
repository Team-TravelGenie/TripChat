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
        completion: @escaping (Error?) -> Void)
    {
        do {
            if let chatEntity = try coreDataService.save(
                entityName: "ChatEntity",
                values: [
                    "id": chat.id,
                    "createdAt": chat.createdAt,
                ]) as? ChatEntity {
                
                try chat.tags.tags.forEach {
                    try createTagEntity(with: $0, addTo: chatEntity)
                }
                
                try chat.recommendations.forEach {
                    try createRecommendationEntity(with: $0, addTo: chatEntity)
                }
                
                try chat.messages.forEach {
                    try createMessageEntity(with: $0, addTo: chatEntity)
                }
            }
        } catch {
            completion(error)
        }
    }
    
    func fetchRecentChats(
        pageSize: Int,
        completion: @escaping (Result<[Chat], Error>) -> Void)
    {
        let request = ChatEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.fetchBatchSize = pageSize
        
        do {
            let result = try coreDataService.fetch(request: request).map { $0.toDomain() }
            completion(.success(result))
        } catch {
            completion(.failure(StorageError.emptyStorage))
        }
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
    
    func deleteChat(
        with id: UUID,
        completion: @escaping (Result<Bool, Error>) -> Void)
    {
        let request = ChatEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let targetObjects = try coreDataService.fetch(request: request, predicate: predicate)
            try targetObjects.forEach {
                try coreDataService.delete(object: $0)
            }
            completion(.success(true))
        } catch {
            completion(.failure(StorageError.noResultForID))
        }
    }
    
    // MARK: Private
    
    private func createTagEntity(
        with tag: Tag,
        addTo chatEntity: ChatEntity) throws
    {
        guard let tagEntity = try coreDataService.save(
            entityName: "TagEntity",
            values: [
                "value": tag.value,
                "isSelected": tag.isSelected,
                "category": tag.category.rawValue,
            ]) as? TagEntity else { return }
        
        chatEntity.addToTags(tagEntity)
    }
    
    private func createRecommendationEntity(
        with recommendation: RecommendationItem,
        addTo chatEntity: ChatEntity) throws
    {
        guard let recommendationEntity = try coreDataService.save(
            entityName: "RecommendationEntity",
            values: [
                "country": recommendation.country,
                "spotKorean": recommendation.spotKorean,
                "spotEnglish": recommendation.spotEnglish,
                "image": recommendation.image,
            ]) as? RecommendationEntity else { return }
        
        chatEntity.addToRecommendations(recommendationEntity)

    }
    
    private func createMessageEntity(
        with message: Message,
        addTo chatEntity: ChatEntity) throws
    {
        var data: Data? = nil
        
        switch message.kind {
        case .attributedText(let attributedText):
            data = try NSKeyedArchiver.archivedData(
                withRootObject: attributedText,
                requiringSecureCoding: true)
        case .photo(let mediaItem):
            let dao = MediaItemDAO(with: mediaItem)
            data = try JSONEncoder().encode(dao)
        case .custom(let item):
            if message.kind.description == "tag" {
                let item = item as? TagItem
                data = try JSONEncoder().encode(item)
            } else if message.kind.description == "recommendation" {
                let item = item as? RecommendationItem
                data = try JSONEncoder().encode(item)
            }
        default:
            break
        }
        
        if let messageEntity = try coreDataService.save(
            entityName: "MessageEntity",
            values: [
                "id": UUID(uuidString: message.messageId)!,
                "kind": message.kind.description,
                "sender": message.sender.displayName,
                "sentDate": message.sentDate,
                "data": data,
            ]) as? MessageEntity {
            chatEntity.addToMessages(messageEntity)
        }
    }
    
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
        let spotKoreanPredicate = NSPredicate(format: "spotKorean CONTAINS[c] %@", keyword)
        let spotEnglishPredicate = NSPredicate(format: "spotEnglish CONTAINS[c] %@", keyword)
        let predicate = NSCompoundPredicate(
            type: .or,
            subpredicates: [
                countryPredicate,
                spotKoreanPredicate,
                spotEnglishPredicate,
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
