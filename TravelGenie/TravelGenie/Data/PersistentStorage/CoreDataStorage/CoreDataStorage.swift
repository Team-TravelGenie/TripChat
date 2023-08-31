//
//  CoreDataService.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/22.
//

import CoreData
import Foundation

final class CoreDataService {
    
    static let shared = CoreDataService()
    
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
    
    func fetch<T>(request: NSFetchRequest<T>, predicate: NSPredicate? = nil) throws -> [T] {
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        let data = try context.fetch(request)
        
        return data
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
        tagEntity.setValue(tag.category.rawValue, forKey: "category")
        
        return tagEntity
    }
    
    private func createRecommendationEntity(with recommendation: RecommendationItem) -> RecommendationEntity {
        let recommendationEntity = RecommendationEntity(context: context)
        recommendationEntity.setValue(recommendation.country, forKey: "country")
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
}
