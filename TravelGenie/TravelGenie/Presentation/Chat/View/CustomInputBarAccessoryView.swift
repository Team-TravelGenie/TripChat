//
//  CustomInputBarAccessoryView.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/03.
//

import InputBarAccessoryView
import UIKit

final class CustomInputBarAccessoryView: InputBarAccessoryView {
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        backgroundColor = .white
        padding = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        configureLeftStackView()
        configureMiddleContentView()
        configureRightStackView()
    }
    
    private func configureLeftStackView() {
        leftStackView.alignment = .bottom
        setLeftStackViewWidthConstant(to: 36, animated: false)
        
        let galleryButton = InputBarButtonItem()
        let galleryButtonImage = UIImage(named: "images-regular")?.withRenderingMode(.alwaysTemplate)
        galleryButton.tintColor = .primary
        galleryButton.setImage(galleryButtonImage, for: .normal)
        galleryButton.setSize(CGSize(width: 36, height: 36), animated: false)
        setStackViewItems([galleryButton], forStack: .left, animated: false)
    }
    
    private func configureMiddleContentView() {
        maxTextViewHeight = 72
        middleContentViewPadding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    
        inputTextView.layer.cornerRadius = 18
        inputTextView.layer.masksToBounds = true
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.borderColor = UIColor.blueGrayLine.cgColor
        inputTextView.backgroundColor = .grayBackground
        inputTextView.textContainer.lineFragmentPadding = 0
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        inputTextView.typingAttributes = TextAttributeCreator.create(font: .bodyRegular, color: .black)
        
        let placeholderText = "무엇이든 물어보세요!"
        inputTextView.placeholderLabel.textColor = .blueGrayFont
        inputTextView.placeholderLabel.font = .systemFont(ofSize: 15)
        inputTextView.placeholder = placeholderText
    }
    
    private func configureRightStackView() {
        rightStackView.alignment = .bottom
        setRightStackViewWidthConstant(to: 32, animated: false)
        
        let sendButtonImage = UIImage(named: "paper-plane")?.withRenderingMode(.alwaysTemplate)
        sendButton.title = nil
        sendButton.tintColor = .primary
        sendButton.setImage(sendButtonImage, for: .normal)
        sendButton.setSize(CGSize(width: 32, height: 32), animated: false)
    }
}
