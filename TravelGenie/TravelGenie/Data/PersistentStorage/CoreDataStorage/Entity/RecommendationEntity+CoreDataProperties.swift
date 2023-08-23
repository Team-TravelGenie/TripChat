//
//  RecommendationEntity+CoreDataProperties.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//
//

import Foundation
import CoreData


extension RecommendationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecommendationEntity> {
        return NSFetchRequest<RecommendationEntity>(entityName: "RecommendationEntity")
    }

    @NSManaged public var value: String
    @NSManaged public var chat: NSSet?

}

// MARK: Generated accessors for chat
extension RecommendationEntity {

    @objc(addChatObject:)
    @NSManaged public func addToChat(_ value: ChatEntity)

    @objc(removeChatObject:)
    @NSManaged public func removeFromChat(_ value: ChatEntity)

    @objc(addChat:)
    @NSManaged public func addToChat(_ values: NSSet)

    @objc(removeChat:)
    @NSManaged public func removeFromChat(_ values: NSSet)

}

extension RecommendationEntity : Identifiable {

}
