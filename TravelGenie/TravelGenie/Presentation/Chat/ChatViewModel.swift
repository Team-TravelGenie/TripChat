//
//  ChatViewModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import UIKit

final class ChatViewModel {
    private let user: Sender = Sender(name: .user)
    
    func makePhotoMessage(_ image: UIImage) -> Message {
        return Message(
            image: image,
            sender: self.user,
            messageId: UUID().uuidString,
            sentDate: Date())
    }
}
