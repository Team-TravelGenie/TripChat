//
//  PopUpContentView.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/26.
//

import UIKit

protocol PopUpContentViewDelegate: AnyObject {
    func dismissPopUp()
    func showFeedbackContentView()
    func dismissAndPop()
    func saveChat()
    func sendFeedback(isPositive: Bool, content: String)
}

final class PopUpContentView: UIView {

    enum PopUpType {
        case normal(PopUpModel) // 콘텐트를 model로 받기
        case feedback(PopUpModel)
    }
    
    weak var delegate: PopUpContentViewDelegate?
    weak var textViewDelegate: UITextViewDelegate? {
        didSet {
            feedbackTextView.delegate = textViewDelegate
        }
    }
    
    let type: PopUpType?
    
    private let mainStackView = UIStackView()
    private let closeButtonStackView = UIStackView()
    private let iconAndMainTextStackView = UIStackView()
    private let feedbackButtonWrapperStackView = UIStackView()
    private let feedbackButtonStackView = UIStackView()
    private let bottomButtonStackView = UIStackView()
    private let closeButton = UIButton()
    private let mainTextView = UITextView()
    private let feedbackTextView = FeedbackTextView()
    private let chatIconView = CircleIconView()
        .size(40)
        .backgroundColor(.blueGrayBackground)
        .iconImage(imageName: "chat", size: 32)
    
    private let thumbsUpButton = FeedbackButton()
        .size(64)
        .image(name: "thumbs-up-regular", size: 28)
    
    private let thumbsDownButton = FeedbackButton()
        .size(64)
        .image(name: "thumbs-down-regular", size: 28)
    
    private let leftButton = RectangleTextButton()
        .cornerRadius(8)
        .backgroundColor(.primary)
    
    private let rightButton = RectangleTextButton()
        .backgroundColor(.white)
        .borderColor(.blueGrayLine)
        .borderWidth(1)
        .cornerRadius(8)
    
    private var feedbackTextViewHeightAnchor: NSLayoutConstraint?

    private var leftButtonHeightAnchor: NSLayoutConstraint?
    private var rightButtonHeightAnchor: NSLayoutConstraint?
    
    private var mainStackViewSpacing: CGFloat = 24 {
        didSet {
            mainStackView.spacing = mainStackViewSpacing
        }
    }
    
    private var isFeedbackSelected: Bool {
        return thumbsUpButton.isSelected || thumbsDownButton.isSelected
    }
    
    // MARK: Lifecycle
    
    init(type: PopUpType) {
        self.type = type
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.masksToBounds = true
        configureContents(with: type)
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override(s)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        feedbackTextView.resignFirstResponder()
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: Internal
    
    func changeFeedbackModalLayout(spacing: CGFloat, textViewHeight: CGFloat) {
        mainStackViewSpacing = spacing
        feedbackTextViewHeightAnchor?.constant = textViewHeight
    }
    
    func changeFeedbackModalLayoutForSE3(
        spacing: CGFloat,
        textViewHeight: CGFloat,
        leftRightButtonHeight: CGFloat)
    {
        mainStackViewSpacing = spacing
        feedbackTextViewHeightAnchor?.constant = textViewHeight
        leftButtonHeightAnchor?.constant = leftRightButtonHeight
        rightButtonHeightAnchor?.constant = leftRightButtonHeight
        feedbackButtonWrapperStackView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
    }
    
    func endFeedbackTextViewEditing() {
        feedbackTextView.resignFirstResponder()
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        configureMainStackView()
        configureCloseButtonStackView()
        configureMessageStackView()
        configureFeedbackButtonStackView()
        configureBottomButtonStackView()
    }
    
    private func configureContents(with type: PopUpType) {
        switch type {
        case .normal(let popUpModel):
            configureMainText(with: popUpModel.mainText)
            configureLeftButtonTitle(with: popUpModel.leftButtonTitle)
            configureRightButtonTitle(with: popUpModel.rightButtonTitle)
            closeButton.addAction(dismissAction(), for: .touchUpInside)
            leftButton.addAction(saveChatAction(), for: .touchUpInside)
            leftButton.addAction(showFeedbackContentView(), for: .touchUpInside)
            rightButton.addAction(dismissAction(), for: .touchUpInside)
        case .feedback(let popUpModel):
            configureMainText(with: popUpModel.mainText)
            configureLeftButtonTitle(with: popUpModel.leftButtonTitle)
            configureRightButtonTitle(with: popUpModel.rightButtonTitle)
            closeButton.addAction(dismissAndPopAction(), for: .touchUpInside)
            leftButton.addAction(submitFeedbackAction(), for: .touchUpInside)
            rightButton.addAction(dismissAndPopAction(), for: .touchUpInside)
        }
    }
    
    private func configureMainText(with text: NSAttributedString) {
        mainTextView.attributedText = text
    }
    
    private func configureLeftButtonTitle(with title: NSAttributedString) {
        leftButton.setAttributedTitle(title, for: .normal)
    }
    
    private func configureRightButtonTitle(with title: NSAttributedString) {
        rightButton.setAttributedTitle(title, for: .normal)
    }
    
    private func configureMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.spacing = mainStackViewSpacing
    }
    
    private func configureCloseButtonStackView() {
        closeButtonStackView.axis = .vertical
        closeButtonStackView.alignment = .trailing
        configureCloseButton()
    }
    
    private func configureCloseButton() {
        let buttonImage = UIImage(systemName: "xmark")
        closeButton.setImage(buttonImage, for: .normal)
        closeButton.tintColor = .black
    }
    
    private func configureMessageStackView() {
        iconAndMainTextStackView.spacing = 8
        iconAndMainTextStackView.alignment = .top
        iconAndMainTextStackView.axis = .horizontal
        configureDescriptionTextView()
    }
    
    private func configureDescriptionTextView() {
        mainTextView.isEditable = false
        mainTextView.isScrollEnabled = false
        mainTextView.backgroundColor = .clear
        mainTextView.textContainerInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
    }
    
    private func configureFeedbackButtonStackView() {
        feedbackButtonWrapperStackView.axis = .vertical
        feedbackButtonWrapperStackView.alignment = .center
        feedbackButtonStackView.spacing = 12
        feedbackButtonStackView.axis = .horizontal
        feedbackButtonStackView.distribution = .fill
        configureThumbsUpButton()
        configureThumbsDownButton()
    }
    
    private func configureThumbsUpButton() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.thumbsUpButton.isSelected.toggle()
            if self.thumbsUpButton.isSelected {
                self.thumbsDownButton.isSelected = false
            }
            self.configureSubmitButton()
            self.feedbackTextView.resignFirstResponder()
        }
        thumbsUpButton.addAction(action, for: .touchUpInside)
    }
    
    private func configureThumbsDownButton() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.thumbsDownButton.isSelected.toggle()
            if self.thumbsDownButton.isSelected {
                self.thumbsUpButton.isSelected = false
            }
            self.configureSubmitButton()
            self.feedbackTextView.resignFirstResponder()
        }
        thumbsDownButton.addAction(action, for: .touchUpInside)
    }
        
    private func configureBottomButtonStackView() {
        bottomButtonStackView.spacing = 8
        bottomButtonStackView.axis = .horizontal
        bottomButtonStackView.distribution = .fillEqually
        configureSubmitButton()
    }
    
    private func configureSubmitButton() {
        guard case .feedback = type else { return }
        leftButton.isEnabled = isFeedbackSelected
        leftButton.layer.opacity = isFeedbackSelected ? 1 : 0.2
    }
    
    private func configureHierarchy() {
        addSubview(mainStackView)
        closeButtonStackView.addArrangedSubview(closeButton)

        [
            closeButtonStackView,
            iconAndMainTextStackView,
            bottomButtonStackView,
        ].forEach { mainStackView.addArrangedSubview($0) }
        
        
        [
            chatIconView,
            mainTextView,
        ].forEach { iconAndMainTextStackView.addArrangedSubview($0) }
        
        [
            thumbsUpButton,
            thumbsDownButton,
        ].forEach { feedbackButtonStackView.addArrangedSubview($0) }
        
        feedbackButtonWrapperStackView.addArrangedSubview(feedbackButtonStackView)
        
        [
            leftButton,
            rightButton,
        ].forEach { bottomButtonStackView.addArrangedSubview($0) }
        
        if case .feedback = type {
            [feedbackTextView, feedbackButtonWrapperStackView].forEach {
                mainStackView.insertArrangedSubview($0, at: 2)
            }
        }
    }
    
    private func configureLayout() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
        
        thumbsUpButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbsUpButton.widthAnchor.constraint(equalToConstant: 64),
            thumbsUpButton.heightAnchor.constraint(equalToConstant: 64),
        ])
        
        thumbsDownButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbsDownButton.widthAnchor.constraint(equalToConstant: 64),
            thumbsDownButton.heightAnchor.constraint(equalToConstant: 64),
        ])
        
        feedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextViewHeightAnchor = feedbackTextView.heightAnchor.constraint(equalToConstant: 100)
        feedbackTextViewHeightAnchor?.isActive = true
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButtonHeightAnchor = leftButton.heightAnchor.constraint(equalToConstant: 48)
        leftButtonHeightAnchor?.isActive = true
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButtonHeightAnchor = rightButton.heightAnchor.constraint(equalToConstant: 48)
        rightButtonHeightAnchor?.isActive = true
    }
    
    // MARK: Button Actions
    
    private func dismissAction() -> UIAction {
        return UIAction { [weak self] _ in
            self?.delegate?.dismissPopUp()
        }
    }
    
    private func showFeedbackContentView() -> UIAction {
        return UIAction { [weak self] _ in
            self?.delegate?.showFeedbackContentView()
        }
    }
    
    private func dismissAndPopAction() -> UIAction {
        return UIAction { [weak self] _ in
            self?.delegate?.dismissAndPop()
        }
    }
    
    private func saveChatAction() -> UIAction {
        return UIAction { [weak self] _ in
            self?.delegate?.saveChat()
        }
    }
    
    private func submitFeedbackAction() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self,
                  (self.thumbsUpButton.isSelected || self.thumbsDownButton.isSelected),
                  (!self.feedbackTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                   self.feedbackTextView.attributedText != FeedbackTextView.placeholderText)
            else {
                self?.feedbackTextView.resignFirstResponder()
                return
            }
            
            self.delegate?.sendFeedback(
                isPositive: self.thumbsUpButton.isSelected,
                content: self.feedbackTextView.text ?? String())
            self.delegate?.dismissAndPop()
        }
    }
}
