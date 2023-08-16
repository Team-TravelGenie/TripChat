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
    
    init(
        text: String,
        sender: SenderType,
        messageId: String,
        sentDate: Date)
    {
        self.init(
            kind: .text(text),
            sender: sender,
            messageId: messageId,
            sentDate: sentDate)
    }
}

extension Message {
    static let MockMessage: [Message] = [
        Message(
            text: "Test 1 (Text Kind) Message.",
            sender: Sender(name: .user),
            messageId: UUID().uuidString,
            sentDate: Date().addingTimeInterval(TimeInterval(-8000))),
        
        Message(
            text: "오늘은 어디로 여행을 떠나고 싶나요? 사진을 보내주시면 원하는 분위기의 여행지를 추천해드릴게요!",
            sender: Sender(name: .ai),
            messageId: UUID().uuidString,
            sentDate: Date().addingTimeInterval(TimeInterval(-7000))),
        
        Message(
            text: "Test 2 (Text Kind) Message.",
            sender: Sender(name: .user),
            messageId: UUID().uuidString,
            sentDate: Date().addingTimeInterval(TimeInterval(-3000))),
    ]
}
