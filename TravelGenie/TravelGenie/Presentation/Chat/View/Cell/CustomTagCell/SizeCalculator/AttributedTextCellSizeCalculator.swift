//
//  AttributedTextCellSizeCalculator.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/31.
//

import MessageKit
import UIKit

final class AttributedTextCellSizeCalculator: MessageSizeCalculator {
    
    override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }
        
        attributes.messageLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 12, right: 20)
    }
    
    override func cellContentHeight(
        for message: MessageType,
        at indexPath: IndexPath)
        -> CGFloat
    {
        let messageContainerHeight = messageContainerSize(for: message, at: indexPath).height
        let avatarHeight = avatarSize(for: message, at: indexPath).height
        
        return max(messageContainerHeight, avatarHeight)
    }
    
    override func messageContainerMaxWidth(
        for message: MessageType,
        at indexPath: IndexPath)
        -> CGFloat
    {
        return 244
    }
    
    override func messageContainerSize(
        for message: MessageType,
        at indexPath: IndexPath)
        -> CGSize
    {
        let size = super.messageContainerSize(
            for: message,
            at: indexPath)
        let labelSize = messageLabelSize(
            for: message,
            at: indexPath)
        let selfWidth = labelSize.width + 20 + 20
        let width = max(selfWidth, size.width)
        let height = size.height + labelSize.height + 12 + 8
        
        return CGSize(width: width, height: height)
    }
    
    func messageLabelSize(
        for message: MessageType,
        at indexPath: IndexPath)
        -> CGSize
    {
        let attributedText: NSAttributedString
        
        let textMessageKind = message.kind
        switch textMessageKind {
        case .attributedText(let text):
            attributedText = text
        default:
            fatalError("messageLabelSize received unhandled MessageDataType: \(message.kind)")
        }
        
        let maxWidth = messageContainerMaxWidth(for: message, at: indexPath) - 20 - 20
        
        return attributedText.size(consideringWidth: maxWidth)
    }
    
    override func messageContainerPadding(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        outgoingMessagePadding = UIEdgeInsets(top: .zero, left: 30, bottom: .zero, right: 8)
        incomingMessagePadding = UIEdgeInsets(top: .zero, left: 8, bottom: .zero, right: 30)
        
        return isFromCurrentSender ? outgoingMessagePadding : incomingMessagePadding
    }
    
    override func avatarSize(
        for message: MessageType,
        at indexPath: IndexPath)
        -> CGSize
    {
        let layoutDelegate = messagesLayout.messagesLayoutDelegate
        let collectionView = messagesLayout.messagesCollectionView
        
        if let size = layoutDelegate.avatarSize(for: message, at: indexPath, in: collectionView) {
          return size
        }
        
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        
        return isFromCurrentSender ? CGSize(width: 0, height: 0) : CGSize(width: 40, height: 40)
    }
    
    override func avatarPosition(for message: MessageType) -> AvatarPosition {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        avatarLeadingTrailingPadding = 12
        
        return isFromCurrentSender ? AvatarPosition(horizontal: .cellTrailing, vertical: .cellTop) : AvatarPosition(horizontal: .cellLeading, vertical: .cellTop)
    }
}
