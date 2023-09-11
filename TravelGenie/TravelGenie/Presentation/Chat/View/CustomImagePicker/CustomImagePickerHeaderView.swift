//
//  CustomImagePickerHeaderView.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/07.
//

import UIKit

protocol CustomImagePickerHeaderViewDelegate: AnyObject {
    func dismissModal()
    func send()
}

final class CustomImagePickerHeaderView: UIView {
    
    weak var delegate: CustomImagePickerHeaderViewDelegate?
    
    private let stackView = UIStackView()
    private let statusLabel = UILabel()
    private let closeButton = CustomButton(backgroundColor: .clear)
        .systemIconImage(name: DesignAsset.xMarkImage, size: 24)
        .tintColor(color: .black)
    
    private let sendButton = CustomButton(backgroundColor: .clear)
        .assetIconImage(name: "paper-plane", size: 24)
        .tintColor(color: .primary)
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func setLabelText(with count: Int) {
        let text = NSMutableAttributedString()
            .text("\(count.description)개 선택 중", font: .bodyBold, color: .black)
        statusLabel.attributedText = text
        statusLabel.textAlignment = .center
    }
    
    func changeSendButtonState(_ state: Bool) {
        sendButton.isEnabled = state
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        stackView.spacing = 12
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        sendButton.isEnabled = false
        sendButton.addAction(sendAction(), for: .touchUpInside)

        closeButton.addAction(dismissAction(), for: .touchUpInside)
    }
    
    private func configureHierarchy() {
        addSubview(stackView)
        [closeButton, statusLabel, sendButton].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func configureLayout() {
        statusLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        closeButton.setContentHuggingPriority(.required, for: .horizontal)
        sendButton.setContentHuggingPriority(.required, for: .horizontal)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }
    
    private func dismissAction() -> UIAction {
        return UIAction { [weak self] _ in
            self?.delegate?.dismissModal()
        }
    }
    
    private func sendAction() -> UIAction {
        return UIAction { [weak self] _ in
            self?.delegate?.send()
        }
    }
}
