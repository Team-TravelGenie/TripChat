//
//  ChatInterfaceViewController.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import UIKit
import MessageKit

class ChatInterfaceViewController: MessagesViewController {
    
    private let defaultSender: Sender = Sender(name: .user)
    var messageList: [Message] = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMessagesCollectionViewAttributes()
    }
    
    private func setupMessagesCollectionViewAttributes() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        customizeMessagesCollectionViewLayout()
    }
    
    private func customizeMessagesCollectionViewLayout() {
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(
            LabelAlignment(
                textAlignment: .right,
                textInsets: .zero))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(
            LabelAlignment(
                textAlignment: .right,
                textInsets: .zero))
        layout?.setMessageIncomingAvatarPosition(
            AvatarPosition(vertical: .messageTop))
    }
}

extension ChatInterfaceViewController: MessagesDataSource {
    var currentSender: SenderType {
        return defaultSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.row]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
}

extension ChatInterfaceViewController: MessagesDisplayDelegate {
    
    func textColor(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> UIColor
    {
        return isFromCurrentSender(message: message) ? .black : .blue // 색상반영부
    }
    
    func backgroundColor(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> UIColor
    {
        return isFromCurrentSender(message: message) ? .black : .blue // 색상반영부
    }
    
    func messageStyle(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> MessageStyle
    {
        return .none
    }
    
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
    {
        let avatarImage = UIImage(systemName: "cloud") // 아바타반영부
        let avatar = Avatar(image: avatarImage)
        avatarView.set(avatar: avatar)
    }
    
    func configureMediaMessageImageView(
        _ imageView: UIImageView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
    {
        // TODO: kind - PhotoCell, CustomCell(Swipe) 타입에 대해서 Cache 구현
    }
}

extension ChatInterfaceViewController: MessagesLayoutDelegate {
    func cellTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> CGFloat
    {
        return 20
    }
    
    func cellBottomLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> CGFloat
    {
        return 20
    }
    
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> CGFloat
    {
        return 15
    }
    
    func messageBottomLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> CGFloat
    {
        return 15
    }
}
