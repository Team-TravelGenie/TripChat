//
//  CoreDataStorage.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/22.
//

import CoreData
import Foundation

final class CoreDataStorage: ChatStorage {
    
    static let shared = CoreDataStorage()
    
    private lazy var persistentContainer: NSPersistentContainer = {        
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage \(error)")
            }
        }
        
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    // MARK: Internal

    func save(
        chat: Chat,
        completion: @escaping (Result<Chat, Error>) -> Void)
    {
        let messages: [Message] = chat.messages
        let chatEntity = ChatEntity(context: context)
        
        chatEntity.setValue(chat.id, forKey: "id")
        chatEntity.setValue(chat.createdAt, forKey: "createdAt")
        
        chat.tags.tags.forEach {
            let tagEntity = createTagEntity(with: $0)
            chatEntity.addToTags(tagEntity)
        }
        
        chat.recommendations.forEach {
            let recommendationEntity = createRecommendationEntity(with: $0)
            chatEntity.addToRecommendations(recommendationEntity)
        }
        
        do {
            try messages.forEach {
                let messageEntity = try createMessageEntity(with: $0)
                chatEntity.addToMessages(messageEntity)
            }
            try saveContext()
            completion(.success(chat))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchRecentChats(
        pageSize: Int,
        completion: @escaping (Result<[Chat], Error>) -> Void)
    {
        let request: NSFetchRequest = ChatEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.fetchBatchSize = pageSize
        
        do {
            let result = try context.fetch(request).map { $0.toDomain() }
            completion(.success(result))
        } catch {
            completion(.failure(error))
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
        let request: NSFetchRequest = ChatEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = predicate
        
        do {
            let targetObjects = try context.fetch(request)
            targetObjects.forEach {
                context.delete($0)
            }
            try saveContext()
            completion(.success(true))
        } catch {
            completion(.failure(StorageError.noResultForID))
        }
    }
    
    // MARK: Private
    
    private func saveContext() throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw StorageError.coreDataSaveFailure(error)
            }
        }
    }
    
    private func createTagEntity(with tag: Tag) -> TagEntity {
        let tagEntity = TagEntity(context: context)
        tagEntity.setValue(tag.value, forKey: "value")
        tagEntity.setValue(tag.isSelected, forKey: "isSelected")
        
        return tagEntity
    }
    
    private func createRecommendationEntity(with recommendation: RecommendationItem) -> RecommendationEntity {
        let recommendationEntity = RecommendationEntity(context: context)
        recommendationEntity.setValue(recommendation.country, forKey: "country")
        recommendationEntity.setValue(recommendation.city, forKey: "city")
        recommendationEntity.setValue(recommendation.spot, forKey: "spot")
        recommendationEntity.setValue(recommendation.image, forKey: "image")
        
        return recommendationEntity
    }
    
    private func createMessageEntity(with message: Message) throws -> MessageEntity {
        var data: Data? = nil
        let messageEntity = MessageEntity(context: context)
        messageEntity.setValue(UUID(uuidString: message.messageId)!, forKey: "id")
        messageEntity.setValue(message.kind.description, forKey: "kind")
        messageEntity.setValue(message.sender.displayName, forKey: "sender")
        messageEntity.setValue(message.sentDate, forKey: "sentDate")
        
        switch message.kind {
        case .text(let text):
            data = try JSONEncoder().encode(text)
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
        messageEntity.setValue(data, forKey: "data")
        
        return messageEntity
    }
    
    private func fetchWithTag(_ tag: String) -> [Chat] {
        var result: [Chat] = []
        let request: NSFetchRequest = TagEntity.fetchRequest()
        let predicate = NSPredicate(format: "value CONTAINS[c] %@", tag)
        request.predicate = predicate
        
        do {
            let tagEntities: [TagEntity] = try context.fetch(request)
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
        let request: NSFetchRequest = RecommendationEntity.fetchRequest()
        let countryPredicate = NSPredicate(format: "country CONTAINS[c] %@", keyword)
        let cityPredicate = NSPredicate(format: "city CONTAINS[c] %@", keyword)
        let spotPredicate = NSPredicate(format: "spot CONTAINS[c] %@", keyword)
        let predicate = NSCompoundPredicate(
            type: .or,
            subpredicates: [
                countryPredicate,
                cityPredicate,
                spotPredicate,])
        request.predicate = predicate
        
        do {
            let recommendationEntities: [RecommendationEntity] = try context.fetch(request)
            recommendationEntities.forEach {
                if let chatEntities = $0.chat?.array as? [ChatEntity] {
                    result.append(contentsOf: chatEntities.map { $0.toDomain() })
                }
            }
            
            return result
        } catch {
            return result
        }
    }
}
