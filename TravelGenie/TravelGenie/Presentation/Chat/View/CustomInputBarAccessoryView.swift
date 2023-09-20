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
    
    weak var inputBarButtonDelegate: CustomInputBarAccessoryViewDelegate?
    
    private lazy var photosButton: InputBarButtonItem = {
        return InputBarButtonItem()
            .onTouchUpInside { [weak self] _ in
            self?.inputBarButtonDelegate?.photosButtonTapped()
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
    
    // MARK: Internal
    
    func updatePhotosButtonState(_ isEnabled: Bool) {
        photosButton.isEnabled = isEnabled
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
        configurePhotosButton()
        
        let wrapperView = createWrapperView(with: photosButton)
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
        configureSendButton()
        
        let wrapperView = createWrapperView(with: sendButton)
        setStackViewItems([wrapperView], forStack: .right, animated: false)
    }
    
    private func configurePhotosButton() {
        let buttonImage = UIImage(named: "images-regular")?.withRenderingMode(.alwaysTemplate)
        photosButton.tintColor = .primary
        photosButton.setImage(buttonImage, for: .normal)
        photosButton.setSize(CGSize(width: 24, height: 24), animated: false)
        photosButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSendButton() {
        let sendButtonImage = UIImage(named: "paper-plane")?.withRenderingMode(.alwaysTemplate)
        sendButton.title = nil
        sendButton.tintColor = .primary
        sendButton.setImage(sendButtonImage, for: .normal)
        sendButton.setSize(CGSize(width: 24, height: 24), animated: false)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func createWrapperView(with button: InputBarButtonItem) -> UIView {
        let wrapperView = UIView()
        wrapperView.addSubview(button)
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -5),
            button.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
        ])
        
        return wrapperView
    }
}

extension InputTextView {
    public override var isEditable: Bool {
        didSet {
            layer.opacity = isEditable ? 1.0 : 0.2
        }
    }
}
