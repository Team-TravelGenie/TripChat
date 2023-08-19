//
//  ChatInterfaceViewController.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import UIKit
import MessageKit

class ChatInterfaceViewController: MessagesViewController, ButtonCellDelegate {
    enum MessagesDefaultSection: Int {
        case systemMessage = 0
        case uploadButtonMessage = 2
    }

    private lazy var tagMessageSizeCalculator = CustomTagLayoutSizeCalculator(
        layout: self.messagesCollectionView.messagesCollectionViewFlowLayout)
    
    let defaultSender: Sender = Sender(name: .user)
    var messageStorage: MessageStorage = MessageStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupMessagesCollectionViewAttributes()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Datasource error")
        }
        
        guard !isSectionReservedForTypingIndicator(indexPath.section) else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        _ = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        if let defaultSection = MessagesDefaultSection(rawValue: indexPath.section) {
            switch defaultSection {
            case .systemMessage:
                return messagesCollectionView.dequeueReusableCell(SystemMessageCell.self, for: indexPath)
            case .uploadButtonMessage:
                let cell = messagesCollectionView.dequeueReusableCell(ButtonCell.self, for: indexPath)
                cell.delegate = self
                return cell
            }
        }

        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    private func bind() {
        messageStorage.didChangedMessageList = {
            self.messagesCollectionView.reloadData()
        }
    }
    
    private func setupMessagesCollectionViewAttributes() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        customizeMessagesCollectionViewLayout()
        cellResistration()
        configureMessagesCollectionViewBackgroundColor()
        messagesCollectionView.reloadData()
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
        messagesCollectionView.register(CustomTagContentCell.self)
    }
    
    private func configureMessagesCollectionViewBackgroundColor() {
        messagesCollectionView.backgroundColor = .blueGrayBackground
    }
    
    func didTapButton() {
        print("Button Did Tapped!")
    }
}

extension ChatInterfaceViewController: MessagesDataSource {
    var currentSender: SenderType {
        return defaultSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageStorage.sectionOfMessageList(indexPath.section)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageStorage.count
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
