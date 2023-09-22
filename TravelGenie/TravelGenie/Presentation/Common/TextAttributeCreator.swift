//
//  TextAttributeCreator.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/24.
//

import UIKit

final class TextAttributeCreator {
    
    static func create(font: Font, color: UIColor) -> [NSAttributedString.Key: Any] {
        let fontSize: CGFloat = font.fontSize
        let systemFont: UIFont = .systemFont(ofSize: fontSize, weight: font.weight)
                
        let style = NSMutableParagraphStyle()
        let lineSpacing: CGFloat = font.lineSpacing
        style.lineSpacing = lineSpacing
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: systemFont,
            .paragraphStyle: style,
            .foregroundColor: color,
        ]
        
        return attributes
    }
}
