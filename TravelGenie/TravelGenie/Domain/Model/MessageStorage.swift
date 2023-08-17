//
//  MessageList.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/17.
//

import Foundation

final class MessageStorage {
    enum Constant {
        static let welcomeText = "오늘은 어디로 여행을 떠나고 싶나요? 사진을 보내주시면 원하는 분위기의 여행지를 추천해드릴게요!"
    }
    
    // MARK: Property
    
    var count: Int {
        return messageList.count
    }
    var didChangedMessageList: (() -> Void)?

    private var messageList: [Message] = [Message]() {
        didSet {
            didChangedMessageList?()
        }
    }
    
    // MARK: Initializer

    init() {
        self.messageList = setupDefaultMessage()
    }
    
    // MARK: Internal
    
    func insertMessage(_ message: Message) {
        messageList.append(message)
    }
    
    func sectionOfMessageList(_ section: Int) -> Message {
        return messageList[section]
    }
    
    // MARK: Private
    
    private func setupDefaultMessage() -> [Message] {
        let defaultMessages = [
            Message(sender: Sender(name: .ai)),
            Message(text: Constant.welcomeText, sender: Sender(name: .ai), sentDate: Date()),
            Message(sender: Sender(name: .ai))
        ]
        
        return defaultMessages
    }
}
