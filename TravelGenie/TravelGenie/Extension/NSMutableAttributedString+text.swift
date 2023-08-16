//
//  NSMutableAttributedString+text.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/15.
//

import UIKit

extension NSMutableAttributedString {
    func text(_ value: String, font: Font, color: UIColor) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        let fontSize: CGFloat = font.fontSize
        let lineHeight: CGFloat = font.lineHeight
        let font: UIFont = .systemFont(ofSize: fontSize, weight: font.weight)
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .paragraphStyle: style,
            .font: font,
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        
        return self
    }
}
