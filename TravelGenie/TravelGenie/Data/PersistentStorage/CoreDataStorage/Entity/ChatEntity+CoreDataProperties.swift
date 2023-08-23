//
//  ChatEntity+CoreDataProperties.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//
//

import Foundation
import CoreData


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
