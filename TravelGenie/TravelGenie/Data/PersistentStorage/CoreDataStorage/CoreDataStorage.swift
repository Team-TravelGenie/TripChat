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
        MessageDAOTransformer.register()
        
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
            let tagEntity = TagEntity(context: context)
            tagEntity.setValue($0.value, forKey: "value")
            tagEntity.setValue($0.isSelected, forKey: "isSelected")
            chatEntity.addToTags(tagEntity)
        }
        
        chat.recommendations.forEach {
            let recommendationEntity = RecommendationEntity(context: context)
            recommendationEntity.setValue($0.country, forKey: "country")
            recommendationEntity.setValue($0.city, forKey: "city")
            recommendationEntity.setValue($0.spot, forKey: "spot")
            recommendationEntity.setValue($0.image, forKey: "image")
            chatEntity.addToRecommendations(recommendationEntity)
        }
        
        do {
            try messages.forEach {
                var data: Data? = nil
                let messageEntity = MessageEntity(context: context)
                messageEntity.setValue(UUID(uuidString: $0.messageId)!, forKey: "id")
                messageEntity.setValue($0.kind.description, forKey: "kind")
                messageEntity.setValue($0.sender.displayName, forKey: "sender")
                messageEntity.setValue($0.sentDate, forKey: "sentDate")
                
                switch $0.kind {
                case .text(let text):
                    data = try JSONEncoder().encode(text)
                case .attributedText(let attributedText):
                    data = try NSKeyedArchiver.archivedData(withRootObject: attributedText, requiringSecureCoding: true)
                case .photo(let mediaItem):
                    let dao = MediaItemDAO(with: mediaItem)
                    data = try JSONEncoder().encode(dao)
                case .custom(let item):
                    if $0.kind.description == "tag" {
                        let item = item as? TagItem
                        data = try JSONEncoder().encode(item)
                    } else if $0.kind.description == "recommendation" {
                        let item = item as? RecommendationItem
                        data = try JSONEncoder().encode(item)
                    }
                default:
                    break
                }
                
                messageEntity.setValue(data, forKey: "data")
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
