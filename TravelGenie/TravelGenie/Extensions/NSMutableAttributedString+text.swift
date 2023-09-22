//
//  NSMutableAttributedString+text.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/15.
//

import UIKit

extension NSMutableAttributedString {
    func text(_ value: String, font: Font, color: UIColor) -> NSMutableAttributedString {
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
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        
        return self
    }
    
    func messageText(_ value: String, font: Font, sender: Sender) -> NSMutableAttributedString {
        let fontSize: CGFloat = font.fontSize
        let systemFont: UIFont = .systemFont(ofSize: fontSize, weight: font.weight)
                
        let style = NSMutableParagraphStyle()
        let lineSpacing: CGFloat = font.lineSpacing
        style.lineSpacing = lineSpacing
        
        let fontColor: UIColor = sender.displayName == "ai" ? .black : .white

        let attributes: [NSAttributedString.Key: Any] = [
            .font: systemFont,
            .paragraphStyle: style,
            .foregroundColor: fontColor,
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        
        return self
    }
    
    func hyperlinkText(_ value: String, hyperlinks: [Hyperlink], font: Font, color: UIColor) -> NSMutableAttributedString {
        let baseAttributedString = text(value, font: font, color: color)
        
        hyperlinks.forEach {
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
