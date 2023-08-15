//
//  Message.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var kind: MessageKind
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    
    private init(
        kind: MessageKind,
        sender: SenderType,
        messageId: String,
        sentDate: Date)
    {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
    }
}
