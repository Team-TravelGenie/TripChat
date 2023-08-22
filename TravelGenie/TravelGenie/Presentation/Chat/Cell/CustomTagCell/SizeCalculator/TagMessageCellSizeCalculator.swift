//
//  TagMessageCellSizeCalculator.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/18.
//

import MessageKit
import UIKit

final class TagMessageCellSizeCalculator: CustomCellSizeCalculator {
    
    override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        return CGSize(width: .zero, height: 500)
    }
}

