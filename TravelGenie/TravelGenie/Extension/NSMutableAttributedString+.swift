//
//  NSMutableAttributedString+.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/15.
//

import UIKit

extension NSMutableAttributedString {
    func largeTitle(_ value: String, color: UIColor, weight: UIFont.Weight) -> NSMutableAttributedString {
        let fontSize: CGFloat = 34
        let style = NSMutableParagraphStyle()
        let lineHeight: CGFloat = fontSize * 1.3
        let font: UIFont = .systemFont(ofSize: fontSize, weight: weight)
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
    
    func title1(_ value: String, color: UIColor, weight: UIFont.Weight) -> NSMutableAttributedString {
        let fontSize: CGFloat = 28
        let style = NSMutableParagraphStyle()
        let lineHeight: CGFloat = fontSize * 1.5
        let font: UIFont = .systemFont(ofSize: fontSize, weight: weight)
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
    
    func title2(_ value: String, color: UIColor, weight: UIFont.Weight) -> NSMutableAttributedString {
        let fontSize: CGFloat = 22
        let style = NSMutableParagraphStyle()
        let lineHeight: CGFloat = fontSize * 1.5
        let font: UIFont = .systemFont(ofSize: fontSize, weight: weight)
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
    
    func title3(_ value: String, color: UIColor, weight: UIFont.Weight) -> NSMutableAttributedString {
        let fontSize: CGFloat = 20
        let style = NSMutableParagraphStyle()
        let lineHeight: CGFloat = fontSize * 1.5
        let font: UIFont = .systemFont(ofSize: fontSize, weight: weight)
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
    
    func headline(_ value: String, color: UIColor, weight: UIFont.Weight) -> NSMutableAttributedString {
        let fontSize: CGFloat = 17
        let style = NSMutableParagraphStyle()
        let lineHeight: CGFloat = fontSize * 1.5
        let font: UIFont = .systemFont(ofSize: fontSize, weight: weight)
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
    
    func body(_ value: String, color: UIColor, weight: UIFont.Weight) -> NSMutableAttributedString {
        let fontSize: CGFloat = 15
        let style = NSMutableParagraphStyle()
        let lineHeight: CGFloat = fontSize * 1.5
        let font: UIFont = .systemFont(ofSize: fontSize, weight: weight)
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
    
    func caption(_ value: String, color: UIColor, weight: UIFont.Weight) -> NSMutableAttributedString {
        let fontSize: CGFloat = 12
        let style = NSMutableParagraphStyle()
        let lineHeight: CGFloat = fontSize * 1.5
        let font: UIFont = .systemFont(ofSize: fontSize, weight: weight)
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
    
    func micro(_ value: String, color: UIColor, weight: UIFont.Weight) -> NSMutableAttributedString {
        let fontSize: CGFloat = 12
        let style = NSMutableParagraphStyle()
        let lineHeight: CGFloat = fontSize * 1
        let font: UIFont = .systemFont(ofSize: fontSize, weight: weight)
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
