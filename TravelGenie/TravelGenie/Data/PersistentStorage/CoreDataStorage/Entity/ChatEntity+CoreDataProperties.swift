//
//  ChatEntity+CoreDataProperties.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//
//

import CoreData
import Foundation
import MessageKit

extension ChatEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatEntity> {
        return NSFetchRequest<ChatEntity>(entityName: "ChatEntity")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var recommendations: NSOrderedSet
    @NSManaged public var tags: NSOrderedSet
    @NSManaged public var messages: NSOrderedSet

}

// MARK: Generated accessors for recommendations
extension ChatEntity {

    @objc(addRecommendationsObject:)
    @NSManaged public func addToRecommendations(_ value: RecommendationEntity)

    @objc(removeRecommendationsObject:)
    @NSManaged public func removeFromRecommendations(_ value: RecommendationEntity)

    @objc(addRecommendations:)
    @NSManaged public func addToRecommendations(_ values: NSSet)

    @objc(removeRecommendations:)
    @NSManaged public func removeFromRecommendations(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension ChatEntity {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TagEntity)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TagEntity)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

// MARK: Generated accessors for messages
extension ChatEntity {

    @objc(insertObject:inMessagesAtIndex:)
    @NSManaged public func insertIntoMessages(_ value: MessageEntity, at idx: Int)

    @objc(removeObjectFromMessagesAtIndex:)
    @NSManaged public func removeFromMessages(at idx: Int)

    @objc(insertMessages:atIndexes:)
    @NSManaged public func insertIntoMessages(_ values: [MessageEntity], at indexes: NSIndexSet)

    @objc(removeMessagesAtIndexes:)
    @NSManaged public func removeFromMessages(at indexes: NSIndexSet)

    @objc(replaceObjectInMessagesAtIndex:withObject:)
    @NSManaged public func replaceMessages(at idx: Int, with value: MessageEntity)

    @objc(replaceMessagesAtIndexes:withMessages:)
    @NSManaged public func replaceMessages(at indexes: NSIndexSet, with values: [MessageEntity])

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageEntity)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageEntity)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSOrderedSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSOrderedSet)

}

extension ChatEntity : Identifiable {

}

// MARK: Mapping to Domain
extension ChatEntity {
    func toDomain() -> Chat {
        var tagList: [Tag] = []
        var messageList: [Message] = []
        var recommendationList: [RecommendationItem] = []
        
        tags.array.forEach {
            if let tagEntity = $0 as? TagEntity {
                let tag = Tag(
                    value: tagEntity.value,
                    isSelected: tagEntity.isSelected)
                tagList.append(tag)
            }
        }
        
        recommendations.array.forEach {
            if let recommendationEntity = $0 as? RecommendationEntity {
                let recommendation = RecommendationItem(
                    country: recommendationEntity.country,
                    city: recommendationEntity.city,
                    spot: recommendationEntity.spot,
                    image: recommendationEntity.image)
                recommendationList.append(recommendation)
            }
        }
        
        messages.array.forEach {
            if let messageEntity = $0 as? MessageEntity {
                let messageKind: String = messageEntity.kind
                let senderName = SenderName(rawValue: messageEntity.sender)
                let sender = Sender(name: senderName ?? .ai)
                var messageModel = Message(sender: sender)
                
                if messageKind == "attributedText" {
                    messageModel = createAttributedTextMessage(
                        with: messageEntity,
                        sender: sender)
                } else if messageKind == "photo" {
                    messageModel = createPhotoMessage(
                        with: messageEntity,
                        sender: sender)
                } else if messageKind == "tag" {
                    messageModel = createTagMessage(
                        with: messageEntity,
                        tagList: tagList)
                } else if messageKind == "recommendation" {
                    messageModel = createRecommendationMessage(
                        with: messageEntity,
                        recommendationList: recommendationList)
                }
                
                messageList.append(messageModel)
            }
        }
        
        return Chat(
            id: id,
            createdAt: createdAt,
            tags: TagItem(tags: tagList),
            recommendations: recommendationList,
            messages: messageList
        )
    }
    
    private func createAttributedTextMessage(
        with entity: MessageEntity,
        sender: Sender)
        -> Message
    {
        let decodedData = try? NSKeyedUnarchiver.unarchivedObject(
            ofClass: NSAttributedString.self,
            from: entity.data ?? .init())
        
        return Message(
            text: decodedData ?? .init(),
            sender: sender,
            messageId: entity.id.uuidString,
            sentDate: entity.sentDate)
    }
    
    private func createPhotoMessage(
        with entity: MessageEntity,
        sender: Sender)
        -> Message
    {
        let decodedData = try? JSONDecoder().decode(
            MediaItemDAO.self,
            from: entity.data ?? .init())
        let url = URL(string: decodedData?.URLString ?? .init())
        
        return Message(
            url: url,
            imageData: decodedData?.imageData,
            sender: sender,
            messageId: entity.id.uuidString,
            sentDate: entity.sentDate)
    }
    
    private func createTagMessage(
        with entity: MessageEntity,
        tagList: [Tag])
        -> Message
    {
        return Message(
            tags: tagList,
            messageId: entity.id.uuidString,
            sentDate: entity.sentDate)
    }
    
    private func createRecommendationMessage(
        with entity: MessageEntity,
        recommendationList: [RecommendationItem])
        -> Message
    {
        return Message(
            recommendations: recommendationList,
            messageId: entity.id.uuidString,
            sentDate: entity.sentDate)
    }
}
