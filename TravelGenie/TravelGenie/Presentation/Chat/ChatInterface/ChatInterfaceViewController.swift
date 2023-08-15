//
//  ChatInterfaceViewController.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import UIKit
import MessageKit

class ChatInterfaceViewController: MessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setupMessagesCollectionViewAttributes() {
        messagesCollectionView.messagesDataSource = self
    }
}

extension ChatInterfaceViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        <#code#>
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        <#code#>
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        <#code#>
    }
}
