//
//  ChatInterfaceViewController.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import UIKit
import MessageKit

class ChatInterfaceViewController: MessagesViewController {
    enum MessagesDefaultSection: Int {
        case systemMessage = 0
        case welcomeMessage = 2
    }
    
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
        cellResistration()
        ConfiguremessagesCollectionViewBackgroundColor()
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
    
    private func cellResistration() {
        messagesCollectionView.register(SystemMessageCell.self)
        messagesCollectionView.register(ButtonCell.self)
    }
    
    private func ConfiguremessagesCollectionViewBackgroundColor() {
        messagesCollectionView.backgroundColor = .blueGrayBackground
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Datasource error")
        }
        
        // Very important to check this when overriding `cellForItemAt`
        // Super method will handle returning the typing indicator cell
        guard !isSectionReservedForTypingIndicator(indexPath.section) else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        if let defaultSection = MessagesDefaultSection(rawValue: indexPath.section) {
            switch defaultSection {
            case .systemMessage:
                return messagesCollectionView.dequeueReusableCell(SystemMessageCell.self, for: indexPath)
            case .welcomeMessage:
                let cell = messagesCollectionView.dequeueReusableCell(ButtonCell.self, for: indexPath)
                cell.delegate = self
                return cell
            }
        }

//        if case .custom = message.kind {
//            let cell = messagesCollectionView.dequeueReusableCell(CustomCell.self, for: indexPath)
//            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
//            return cell
//        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
}

extension ChatInterfaceViewController: MessagesDataSource {
    var currentSender: SenderType {
        return defaultSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
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
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> UIColor
    {
        return isFromCurrentSender(message: message) ? .primary : .tertiary
    }
    
    func messageStyle(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
        -> MessageStyle
    {
        return .bubble
    }
    
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
    {
        let avatarImage = UIImage(named: "chat")
        let avatar = Avatar(image: avatarImage)
        avatarView.backgroundColor = .white
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

extension ChatInterfaceViewController: ButtonCellDelegate {
    func didTapButton(in _: UICollectionViewCell) {
        print("ABC")
    }
}
