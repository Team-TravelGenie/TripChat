//
//  ButtonMessageCellSizeCalculator.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/21.
//

import Foundation
import MessageKit

final class ButtonMessageCellSizeCalculator: CustomCellSizeCalculator {
    
    override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        return CGSize(width: messagesLayout.itemWidth, height: 130)
    }
    
}
