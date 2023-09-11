//
//  CustomInputBarAccessoryView.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/03.
//

import InputBarAccessoryView
import UIKit

protocol CustomInputBarAccessoryViewDelegate: AnyObject {
    func photosButtonTapped()
}

final class CustomInputBarAccessoryView: InputBarAccessoryView {
    
    weak var photosButtonDelegate: CustomInputBarAccessoryViewDelegate?
    
    private lazy var photosButton: InputBarButtonItem = {
        return InputBarButtonItem()
            .onTouchUpInside { [weak self] _ in
            self?.photosButtonDelegate?.photosButtonTapped()
        }
    }()
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
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
        leftStackView.alignment = .fill
        setLeftStackViewWidthConstant(to: 24, animated: false)
        
        let galleryButtonImage = UIImage(named: "images-regular")?.withRenderingMode(.alwaysTemplate)
        photosButton.tintColor = .primary
        photosButton.setImage(galleryButtonImage, for: .normal)
        photosButton.setSize(CGSize(width: 24, height: 24), animated: false)
        photosButton.translatesAutoresizingMaskIntoConstraints = false

        let wrapperView = UIView()
        wrapperView.addSubview(photosButton)
        NSLayoutConstraint.activate([
            photosButton.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -5),
            photosButton.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            photosButton.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
        ])
        setStackViewItems([wrapperView], forStack: .left, animated: false)
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
        rightStackView.alignment = .fill
        rightStackView.removeArrangedSubview(sendButton)
        setRightStackViewWidthConstant(to: 24, animated: false)
        
        let sendButtonImage = UIImage(named: "paper-plane")?.withRenderingMode(.alwaysTemplate)
        sendButton.title = nil
        sendButton.tintColor = .primary
        sendButton.setImage(sendButtonImage, for: .normal)
        sendButton.setSize(CGSize(width: 24, height: 24), animated: false)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        let wrapperView = UIView()
        wrapperView.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -5),
            sendButton.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            sendButton.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
        ])
        setStackViewItems([wrapperView], forStack: .right, animated: false)
    }
}
