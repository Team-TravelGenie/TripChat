//
//  RecommendationCellSizeCalculator.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import MessageKit
import UIKit

final class RecommendationCellSizeCalculator: CustomCellSizeCalculator {
    
    override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        return CGSize(width: messagesLayout.itemWidth, height: 247)
    }
}
