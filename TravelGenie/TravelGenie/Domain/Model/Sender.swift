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

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    
    init(senderId: String, displayName: SenderName) {
        self.senderId = senderId
        self.displayName = displayName.rawValue
    }
}
