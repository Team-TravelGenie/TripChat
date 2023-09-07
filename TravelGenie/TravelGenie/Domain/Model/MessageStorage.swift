//
//  MessageList.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/17.
//

import Foundation

final class MessageStorage {
    
    // MARK: Property
    
    var count: Int {
        return messageList.count
    }
    var didChangeMessageList: (() -> Void)?

    private var messageList: [Message] = [Message]() {
        didSet {
            didChangeMessageList?()
        }
    }
        
    // MARK: Internal
    
    func insertMessage(_ message: Message) {
        messageList.append(message)
    }
    
    func sectionOfMessageList(_ section: Int) -> Message {
        return messageList[section]
    }
    
    func fetchMessages() -> [Message] {
        return messageList
	}

    func findTagMessageIndex() -> Int? {
        return messageList.firstIndex(where: {
            if case let .custom(item) = $0.kind, item is TagItem {
                return true
            }
            return false
        })
    }
}
