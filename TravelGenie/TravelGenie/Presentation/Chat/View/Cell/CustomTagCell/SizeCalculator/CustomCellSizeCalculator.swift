//
//  CustomCellSizeCalculator.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/18.
//

import MessageKit
import UIKit

class CustomCellSizeCalculator: CellSizeCalculator {
    
    init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        layout?.sectionInset = UIEdgeInsets(top: 4, left: .zero, bottom: 4, right: .zero)
        self.layout = layout
    }
    
    // MARK: Internal
    
    var messagesLayout: MessagesCollectionViewFlowLayout {
        layout as! MessagesCollectionViewFlowLayout
    }
    
    var messageContainerMaxWidth: CGFloat {
        return messagesLayout.itemWidth
    }
    
    var messagesDataSource: MessagesDataSource {
        self.messagesLayout.messagesDataSource
    }
    
    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let dataSource = messagesDataSource
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)
        let itemHeight = cellContentHeight(for: message, at: indexPath)
        
        return CGSize(width: messagesLayout.itemWidth, height: itemHeight)
    }
    
    func cellContentHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        return messageContainerSize(for: message, at: indexPath).height
    }
    
    // MARK: - MessageContainer
    
    func messageContainerSize(
        for message: MessageType,
        at indexPath: IndexPath)
        -> CGSize
    {
        return CGSize(width: 300, height: 500)
    }
    
    func messageContainerFrame(
        for message: MessageType,
        at indexPath: IndexPath,
        fromCurrentSender: Bool)
        -> CGRect
    {
        let size = messageContainerSize(for: message, at: indexPath)
        let origin: CGPoint
        
        if fromCurrentSender {
            let x = messagesLayout.itemWidth - size.width
            origin = CGPoint(x: x, y: .zero)
        } else {
            origin = CGPoint(x: 0, y: 0)
        }
        
        return CGRect(origin: origin, size: size)
    }
}
