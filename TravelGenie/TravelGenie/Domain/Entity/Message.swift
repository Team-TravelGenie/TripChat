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
    
    // MARK: AttributedText Kind Init
    
    init(
        text: NSAttributedString,
        sender: SenderType,
        messageId: String = UUID().uuidString,
        sentDate: Date)
    {
        self.init(
            kind: .attributedText(text),
            sender: sender,
            messageId: messageId,
            sentDate: sentDate)
    }
    
    // MARK: Photo Kind Init
    
    init(
        url: URL? = nil,
        image: UIImage? = nil,
        imageData: Data? = nil,
        sender: SenderType,
        messageId: String = UUID().uuidString,
        sentDate: Date)
    {
        let mediaItem = ImageMediaItem(url: url, image: image, imageData: imageData)
        self.init(
            kind: .photo(mediaItem),
            sender: sender,
            messageId: messageId,
            sentDate: sentDate)
    }
    
    // MARK: Tag Kind Init
    
    init(
        tags: [Tag],
        messageId: String = UUID().uuidString,
        sentDate: Date = Date()
    ) {
        let tagItem = TagItem(tags: tags)
        self.init(
            kind: .custom(tagItem),
            sender: Sender(name: .ai),
            messageId: messageId,
            sentDate: sentDate)
    }
    
    // MARK: Recommendation Kind Init
    
    init(
        recommendations: [RecommendationItem],
        messageId: String = UUID().uuidString,
        sentDate: Date = Date())
    {
        self.init(
            kind: .custom(recommendations),
            sender: Sender(name: .ai),
            messageId: messageId,
            sentDate: sentDate)
    }
    
    // MARK: LoadingAnimation Kind Cell
    
    init(
        sender: SenderType,
        messageId: String = UUID().uuidString,
        sentDate: Date = Date()
    ) {
        self.init(
            kind: .custom(LoadingAnimationItem()),
            sender: sender,
            messageId: messageId,
            sentDate: sentDate)
    }
    
    // MARK: Blank Init (default Message에 사용됨)
    
    init(sender: SenderType) {
        self.init(
            text: NSAttributedString(),
            sender: sender,
            sentDate: Date())
    }
    
    // MARK: Private
    
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
