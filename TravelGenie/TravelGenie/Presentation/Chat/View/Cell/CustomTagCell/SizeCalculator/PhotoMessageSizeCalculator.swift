//
//  PhotoMessageSizeCalculator.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/06.
//

import MessageKit
import UIKit

final class PhotoMessageSizeCalculator: MediaMessageSizeCalculator {
    override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = 244
        let maxHeight: CGFloat = 244
        
        let sizeForMediaItem = { (item: MediaItem) -> CGSize in
            if item.size.width > item.size.height {
                if maxWidth < item.size.width {
                    // Maintain the ratio if width is too great
                    let height = maxWidth * item.size.height / item.size.width
                    return CGSize(width: maxWidth, height: height)
                }
                
                return item.size
            } else {
                if maxHeight < item.size.height {
                    // Maintain the ratio if height is too great
                    let width = maxHeight * item.size.width / item.size.height
                    return CGSize(width: width, height: maxHeight)
                }
                
                return item.size
            }
        }
        
        switch message.kind {
        case .photo(let item):
            return sizeForMediaItem(item)
        default:
            return CGSize()
        }
    }
    
    override func avatarSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let layoutDelegate = messagesLayout.messagesLayoutDelegate
        let collectionView = messagesLayout.messagesCollectionView
        
        if let size = layoutDelegate.avatarSize(for: message, at: indexPath, in: collectionView) {
          return size
        }
        
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        
        return isFromCurrentSender ? CGSize(width: 0, height: 0) : CGSize(width: 40, height: 40)
    }
}
