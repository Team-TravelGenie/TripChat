//
//  CustomLayoutSizeCalculator.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/18.
//

import MessageKit
import UIKit

class CustomLayoutSizeCalculator: CellSizeCalculator {
    
    init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        
        self.layout = layout
    }
    
    // MARK: Internal
    
    var cellTopLabelVerticalPadding: CGFloat = 32
    var cellTopLabelHorizontalPadding: CGFloat = 32
    var cellMessageContainerHorizontalPadding: CGFloat = 48
    var cellMessageContainerExtraSpacing: CGFloat = 16
    var cellMessageContentVerticalPadding: CGFloat = 16
    var cellMessageContentHorizontalPadding: CGFloat = 16
    var cellDateLabelHorizontalPadding: CGFloat = 24
    var cellDateLabelBottomPadding: CGFloat = 8
    
    var messagesLayout: MessagesCollectionViewFlowLayout {
        layout as! MessagesCollectionViewFlowLayout
    }
    
    var messageContainerMaxWidth: CGFloat {
        messagesLayout.itemWidth -
        cellMessageContainerHorizontalPadding -
        cellMessageContainerExtraSpacing
    }
    
    var messagesDataSource: MessagesDataSource {
        self.messagesLayout.messagesDataSource
    }
    
    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let dataSource = messagesDataSource
        let message = dataSource.messageForItem(
            at: indexPath,
            in: messagesLayout.messagesCollectionView)
        let itemHeight = cellContentHeight(
            for: message,
            at: indexPath)
        return CGSize(
            width: messagesLayout.itemWidth,
            height: itemHeight)
    }
    
    func cellContentHeight(
        for message: MessageType,
        at indexPath: IndexPath)
    -> CGFloat
    {
        messageContainerSize(
            for: message,
            at: indexPath).height
    }
    
    // MARK: - Top cell Label
    
    func cellTopLabelSize(
        for message: MessageType,
        at indexPath: IndexPath)
    -> CGSize
    {
        return .zero
    }
    
    func cellTopLabelFrame(
        for message: MessageType,
        at indexPath: IndexPath)
    -> CGRect
    {
        return .zero
    }
    
    func cellMessageBottomLabelSize(
        for message: MessageType,
        at indexPath: IndexPath)
    -> CGSize
    {
        return .zero
    }
    
    func cellMessageBottomLabelFrame(
        for message: MessageType,
        at indexPath: IndexPath)
    -> CGRect
    {
        return .zero
    }
    
    // MARK: - MessageContainer
    
    func messageContainerSize(
        for message: MessageType,
        at indexPath: IndexPath)
    -> CGSize
    {
//        let labelSize = cellMessageBottomLabelSize(
//            for: message,
//            at: indexPath)
//        let width = labelSize.width +
//        cellMessageContentHorizontalPadding +
//        cellDateLabelHorizontalPadding
//        let height = labelSize.height +
//        cellMessageContentVerticalPadding +
//        cellDateLabelBottomPadding
        
        return CGSize(
            width: 300,
            height: 500)
    }
    
    func messageContainerFrame(
        for message: MessageType,
        at indexPath: IndexPath,
        fromCurrentSender: Bool)
    -> CGRect
    {
        let y = cellTopLabelSize(
            for: message,
            at: indexPath).height
        let size = messageContainerSize(
            for: message,
            at: indexPath)
        let origin: CGPoint
        if fromCurrentSender {
            let x = messagesLayout.itemWidth -
            size.width -
            (cellMessageContainerHorizontalPadding / 2)
            origin = CGPoint(x: x, y: y)
        } else {
            origin = CGPoint(
                x: cellMessageContainerHorizontalPadding / 2,
                y: y)
        }
        
        return CGRect(
            origin: origin,
            size: size)
    }
}
