//
//  CustomTextLayoutSizeCalculator.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/18.
//

import MessageKit
import UIKit

final class CustomTagLayoutSizeCalculator: CustomCellSizeCalculator {
    var messageLabelFont = UIFont.preferredFont(forTextStyle: .body)
    var cellMessageContainerRightSpacing: CGFloat = 16
    
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
        let selfWidth = labelSize.width + cellMessageContainerRightSpacing
        let width = max(selfWidth, size.width)
        let height = size.height + labelSize.height
        
        return CGSize(
            width: 1000,
            height: 1000)
    }
    
    func messageLabelSize(
        for message: MessageType,
        at _: IndexPath)
        -> CGSize
    {
        let attributedText: NSAttributedString
        
        let textMessageKind = message.kind
        switch textMessageKind {
        case .custom(let tagItem):
            guard let tagItem = tagItem as? TagItem else {
                fatalError("Can not find TagItem")
            }
            
            attributedText = NSAttributedString(string: tagItem.text, attributes: [.font: messageLabelFont])
        default:
            fatalError("messageLabelSize received unhandled MessageDataType: \(message.kind)")
        }
        
        let maxWidth = messageContainerMaxWidth - cellMessageContainerRightSpacing
        
        return attributedText.size(consideringWidth: maxWidth)
    }
    
    func messageLabelFrame(
        for message: MessageType,
        at indexPath: IndexPath)
        -> CGRect
    {
        let origin = CGPoint(x: 0, y: 0)
        let size = messageLabelSize(for: message, at: indexPath)
        
        return CGRect(origin: origin, size: size)
    }
}

