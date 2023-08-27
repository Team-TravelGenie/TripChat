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
    func sendFeedback(_ feedback: UserFeedback)
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
        .size(72)
        .image(name: "thumbs-up-regular", size: 32)
    
    private let thumbsDownButton = FeedbackButton()
        .size(72)
        .image(name: "thumbs-down-regular", size: 32)
    
    private let leftButton = RectangleTextButton()
        .cornerRadius(8)
        .backgroundColor(.primary)
    
    private let rightButton = RectangleTextButton()
        .backgroundColor(.white)
        .borderColor(.blueGrayLine)
        .borderWidth(1)
        .cornerRadius(8)
    
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
        mainStackView.spacing = 24
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
        feedbackButtonStackView.spacing = 12
        feedbackButtonStackView.axis = .horizontal
        feedbackButtonStackView.distribution = .equalCentering
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
        }
        thumbsDownButton.addAction(action, for: .touchUpInside)
    }
        
    private func configureBottomButtonStackView() {
        bottomButtonStackView.spacing = 8
        bottomButtonStackView.axis = .horizontal
        bottomButtonStackView.distribution = .fillEqually
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
            UIView(),
            thumbsUpButton,
            thumbsDownButton,
            UIView(),
        ].forEach { feedbackButtonStackView.addArrangedSubview($0) }
        
        
        [
            leftButton,
            rightButton,
        ].forEach { bottomButtonStackView.addArrangedSubview($0) }
        
        if case .feedback = type {
            [feedbackTextView, feedbackButtonStackView].forEach {
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
            thumbsUpButton.widthAnchor.constraint(equalToConstant: 72),
            thumbsUpButton.heightAnchor.constraint(equalToConstant: 72),
        ])
        
        thumbsDownButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbsDownButton.widthAnchor.constraint(equalToConstant: 72),
            thumbsDownButton.heightAnchor.constraint(equalToConstant: 72),
        ])
        
        feedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedbackTextView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftButton.heightAnchor.constraint(equalToConstant: 47),
        ])
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightButton.heightAnchor.constraint(equalToConstant: 47),
        ])
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
    private func submitFeedbackAction() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self,
                  (self.thumbsUpButton.isSelected || self.thumbsDownButton.isSelected),
                  (!self.feedbackTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                   self.feedbackTextView.attributedText != FeedbackTextView.placeholderText)
            else { return }
            
            let userFeedback = UserFeedback(
                isPositive: self.thumbsUpButton.isSelected,
                content: self.feedbackTextView.text)
            
            self.delegate?.sendFeedback(userFeedback)
            self.delegate?.dismissAndPop()
        }
    }
}
