//
//  TagEntity+CoreDataProperties.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//
//

import Foundation
import CoreData


extension TagEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagEntity> {
        return NSFetchRequest<TagEntity>(entityName: "TagEntity")
    }

    @NSManaged public var category: String
    @NSManaged public var value: String
    @NSManaged public var isSelected: Bool
    @NSManaged public var chat: NSOrderedSet?

}

// MARK: Generated accessors for chat
extension TagEntity {

    @objc(insertObject:inChatAtIndex:)
    @NSManaged public func insertIntoChat(_ value: ChatEntity, at idx: Int)

    @objc(removeObjectFromChatAtIndex:)
    @NSManaged public func removeFromChat(at idx: Int)

    @objc(insertChat:atIndexes:)
    @NSManaged public func insertIntoChat(_ values: [ChatEntity], at indexes: NSIndexSet)

    @objc(removeChatAtIndexes:)
    @NSManaged public func removeFromChat(at indexes: NSIndexSet)

    @objc(replaceObjectInChatAtIndex:withObject:)
    @NSManaged public func replaceChat(at idx: Int, with value: ChatEntity)

    @objc(replaceChatAtIndexes:withChat:)
    @NSManaged public func replaceChat(at indexes: NSIndexSet, with values: [ChatEntity])

    @objc(addChatObject:)
    @NSManaged public func addToChat(_ value: ChatEntity)

    @objc(removeChatObject:)
    @NSManaged public func removeFromChat(_ value: ChatEntity)

    @objc(addChat:)
    @NSManaged public func addToChat(_ values: NSOrderedSet)

    @objc(removeChat:)
    @NSManaged public func removeFromChat(_ values: NSOrderedSet)

}

extension TagEntity : Identifiable {

}
