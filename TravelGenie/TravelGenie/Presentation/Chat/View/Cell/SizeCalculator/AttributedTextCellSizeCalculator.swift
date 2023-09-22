//
//  AttributedTextCellSizeCalculator.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/31.
//

import MessageKit
import UIKit

final class AttributedTextCellSizeCalculator: MessageSizeCalculator {
    
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
        let labelSize = messageLabelSize(for: message, at: indexPath)
        let messageInsets = UIEdgeInsets(
            top: Design.verticalPadding,
            left: Design.horizontalPadding,
            bottom: Design.verticalPadding,
            right: Design.horizontalPadding)
        
        return CGSize(
            width: labelSize.width + messageInsets.left + messageInsets.right,
            height: labelSize.height + messageInsets.top + messageInsets.bottom)
    }
    
    override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }
        
        attributes.messageLabelInsets = UIEdgeInsets(
            top: Design.verticalPadding,
            left: Design.horizontalPadding,
            bottom: Design.verticalPadding,
            right: Design.horizontalPadding)
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

        let maxWidth = messageContainerMaxWidth(for: message, at: indexPath) - Design.horizontalPadding * 2
        let constraintBox = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let messageLabelSize = attributedText.boundingRect(
            with: constraintBox,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil)
            .integral
        
        return messageLabelSize.size
    }
}

private extension AttributedTextCellSizeCalculator {
    enum Design {
        static let horizontalPadding: CGFloat = 20
        static let verticalPadding: CGFloat = 12
    }
}
