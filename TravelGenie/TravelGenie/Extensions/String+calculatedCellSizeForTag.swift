//
//  String+calculatedCellSizeForTag.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/18.
//

import UIKit

extension String {
    func calculatedCellSizeForTag() -> CGSize {
        let prefixedTagValue = "#\(self)"
        
        let font = UIFont.systemFont(ofSize: Font.bodyBold.fontSize, weight: Font.bodyBold.weight)
        let tagValueSize = (prefixedTagValue as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        
        let leadingTrailingPadding: CGFloat = 20.0 * 2
        
        let widthResult = tagValueSize.width + leadingTrailingPadding
        let defaultHeight: CGFloat = 47.0
        
        return CGSize(width: widthResult, height: defaultHeight)
    }
}
