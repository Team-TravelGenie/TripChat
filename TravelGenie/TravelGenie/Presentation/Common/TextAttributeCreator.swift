//
//  TextAttributeCreator.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/24.
//

import UIKit

final class TextAttributeCreator {
    
    static func create(
        font: Font,
        color: UIColor)
        -> [NSAttributedString.Key: Any]
    {
        let fontSize: CGFloat = font.fontSize
        let lineHeight: CGFloat = font.lineHeight
        let font: UIFont = .systemFont(ofSize: fontSize, weight: font.weight)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font,
            .baselineOffset: (lineHeight - font.lineHeight) / 4,
        ]
        
        return attributes
    }
}
