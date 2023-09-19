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
            .baselineOffset: (lineHeight - font.lineHeight) / 4,
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        
        return self
    }
    
    func messageText(_ value: String, font: Font, sender: Sender) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        let fontSize: CGFloat = font.fontSize
        let lineHeight: CGFloat = font.lineHeight
        let font: UIFont = .systemFont(ofSize: fontSize, weight: font.weight)
        let fontColor: UIColor = sender.displayName == "ai" ? .black : .white
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: fontColor,
            .paragraphStyle: style,
            .font: font,
            .baselineOffset: (lineHeight - font.lineHeight) / 4,
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        
        return self
    }
    
    func linkText(_ value: String, hyperLinks: [HyperLink], font: Font, color: UIColor) -> NSMutableAttributedString {
        let baseAttributedString = text(value, font: font, color: color)
        
        hyperLinks.forEach {
            if let range = value.range(of: $0.text) {
                let nsRange = NSRange(range, in: value)
                
                let linkAttributes: [NSAttributedString.Key: Any] = [
                    .link: $0.url,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]
                
                linkAttributes.forEach { key, value in
                    baseAttributedString.addAttribute(key, value: value, range: nsRange)
                }
            }
        }
        
        return baseAttributedString
    }
}
