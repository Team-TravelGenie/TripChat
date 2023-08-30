//
//  Sender.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import Foundation
import MessageKit

enum SenderName: String {
    case ai
    case user
}

struct Sender: SenderType, Equatable {
    var senderId: String
    var displayName: String
    
    init(name senderName: SenderName) {
        self.senderId = senderName.rawValue
        self.displayName = senderName.rawValue
    }
}
