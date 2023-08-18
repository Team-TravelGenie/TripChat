//
//  CustomTagContentCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/18.
//

import UIKit
import MessageKit

final class CustomTagContentCell: CustomMessageContentCell {
    var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .brown
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        messageLabel.attributedText = nil
        messageLabel.text = nil
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        messageContainerView.addSubview(messageLabel)
    }
    
    override func configure(
        with message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView,
        dataSource: MessagesDataSource,
        and sizeCalculator: CustomLayoutSizeCalculator)
    {
        super.configure(
            with: message,
            at: indexPath,
            in: messagesCollectionView,
            dataSource: dataSource,
            and: sizeCalculator)
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            return
        }
        
        let calculator = sizeCalculator as? CustomTextLayoutSizeCalculator
        messageLabel.frame = calculator?.messageLabelFrame(
            for: message,
            at: indexPath) ?? .zero
        
        let textMessageKind = message.kind
        switch textMessageKind {
        case .text(let text):
            let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
            messageLabel.text = text
            messageLabel.textColor = textColor
        default:
            break
        }
    }
    
}
