//
//  Message.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var kind: MessageKind
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    
    // MARK: Text Kind Init
    
    init(
        text: String,
        sender: SenderType,
        sentDate: Date)
    {
        self.init(
            kind: .text(text),
            sender: sender,
            messageId: UUID().uuidString,
            sentDate: sentDate)
    }
    
    // MARK: Photo Kind Init
    
    init(
        image: UIImage,
        sender: SenderType,
        sentDate: Date)
    {
        let mediaItem = ImageMediaItem(image: image)
        self.init(
            kind: .photo(mediaItem),
            sender: sender,
            messageId: UUID().uuidString,
            sentDate: sentDate)
    }
    
    // MARK: Tag Kind Init
    
    init(tags: [Tag]) {
        let tagItem = TagItem(tags: tags)
        self.init(
            kind: .custom(tagItem),
            sender: Sender(name: .ai),
            messageId: UUID().uuidString,
            sentDate: Date())
    }
    
    // MARK: Recommendation Kind Init
    
    init(
        recommendations: [RecommendationItem],
        sender: SenderType,
        sentDate: Date)
    {
        self.init(
            kind: .custom(recommendations),
            sender: sender,
            messageId: UUID().uuidString,
            sentDate: sentDate)
    }
    
    // MARK: Blank Init (default Message에 사용됨)
    
    init(sender: SenderType) {
        self.init(
            text: "",
            sender: sender,
            sentDate: Date())
    }
    
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
