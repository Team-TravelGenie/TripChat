//
//  FeedbackTextView.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/25.
//

import UIKit

final class FeedbackTextView: UITextView {
    
    static let placeholderText = NSMutableAttributedString()
        .text("그 밖의 의견이 있으시면 부탁드려요!", font: .bodyRegular, color: .blueGrayFont)
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        backgroundColor = .clear
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderColor = UIColor.blueGrayLine.cgColor
        attributedText = FeedbackTextView.placeholderText
        textContainerInset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        typingAttributes = TextAttributeCreator.create(font: .bodyRegular, color: .black)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
