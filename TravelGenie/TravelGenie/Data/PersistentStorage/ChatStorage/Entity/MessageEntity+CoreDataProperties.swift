//
//  MessageEntity+CoreDataProperties.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//
//

import Foundation
import CoreData


extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var kind: String
    @NSManaged public var sender: String
    @NSManaged public var sentDate: Date
    @NSManaged public var data: Data?
    @NSManaged public var chat: ChatEntity

}

extension MessageEntity : Identifiable {

}
