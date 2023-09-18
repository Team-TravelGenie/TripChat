//
//  String+calculatedCellSizeForTag.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/18.
//

import UIKit

extension String {
    func calculatedCellSizeForTag() -> CGSize {
        let font = UIFont.systemFont(ofSize: Font.bodyBold.fontSize, weight: Font.bodyBold.weight)
        let tagValueSize = (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        
        let padding: CGFloat = 40.0
        let sizeAdjustment: CGFloat = 8.0
        let defaultHeight: CGFloat = 47.0

        let widthResult = tagValueSize.width + padding + sizeAdjustment
        
        return CGSize(width: widthResult, height: defaultHeight)
    }
}
