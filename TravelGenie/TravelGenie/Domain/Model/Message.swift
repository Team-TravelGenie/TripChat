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

// MARK: Content MediaItem(s)

extension Message {
    fileprivate struct ImageMediaItem: MediaItem {
        var url: URL?
        var image: UIImage?
        var placeholderImage: UIImage
        var size: CGSize
        
        init(image: UIImage) {
            self.image = image
            size = CGSize(width: 240, height: 240) // 사진별로 사이즈 달라지도록 설정해줘야할 듯?
            placeholderImage = UIImage()
        }
    }
}
