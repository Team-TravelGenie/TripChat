//
//  LoadingResponseMessageSizeCalculator.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/07.
//

import MessageKit
import UIKit

final class LoadingResponseMessageSizeCalculator: CustomCellSizeCalculator {
    
    override func messageContainerSize(
        for message: MessageType,
        at indexPath: IndexPath)
        -> CGSize
    {
        return CGSize(width: messagesLayout.itemWidth, height: 40)
    }
}
