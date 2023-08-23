//
//  CoreDataStorage.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/22.
//

import CoreData
import Foundation

final class CoreDataStorage {
    
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

    func create(_ chat: Chat) {
        let tags: [String] = chat.tags
        let messages: [Message] = chat.messages
        let recommendations: [String] = chat.recommendations
        let chatEntity = ChatEntity(context: context)
        
        chatEntity.setValue(chat.id, forKey: "id")
        chatEntity.setValue(chat.createdAt, forKey: "createdAt")
        
        tags.forEach {
            let tagEntity = TagEntity(context: context)
            tagEntity.value = $0
            chatEntity.addToTags(tagEntity)
        }
        
        recommendations.forEach {
            let recommendationEntity = RecommendationEntity(context: context)
            recommendationEntity.value = $0
            chatEntity.addToRecommendations(recommendationEntity)
        }
        
        messages.forEach {
            var data: Data? = nil
            let messageEntity = MessageEntity(context: context)
            messageEntity.setValue(UUID(uuidString: $0.messageId)!, forKey: "id")
            messageEntity.setValue($0.kind.description, forKey: "kind")
            messageEntity.setValue($0.sender.displayName, forKey: "sender")
            messageEntity.setValue($0.sentDate, forKey: "sentDate")
            
            switch $0.kind {
            case .text(let text):
                data = try? JSONEncoder().encode(text)
            case .attributedText(let attributedText):
                data = try? NSKeyedArchiver.archivedData(withRootObject: attributedText, requiringSecureCoding: true)
            case .photo(let mediaItem):
                let dao = MediaItemDAO(with: mediaItem)
                data = try? JSONEncoder().encode(dao)
            case .video(let mediaItem):
                let dao = MediaItemDAO(with: mediaItem)
                data = try? JSONEncoder().encode(dao)
            case .custom(let item):
                if $0.kind.description == "tag" {
                    let item = item as? TagItem
                    data = try? JSONEncoder().encode(item)
                } else if $0.kind.description == "recommendation" {
                    let item = item as? RecommendationItem
                    data = try? JSONEncoder().encode(item)
                }
            default:
                break
            }
            
            messageEntity.setValue(data, forKey: "data")
        }

        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(StorageError.coreDataSaveFailure(error))
            }
        }
    }
}
