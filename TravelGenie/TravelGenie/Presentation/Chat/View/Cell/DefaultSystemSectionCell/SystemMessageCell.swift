//
//  WelcomeMessageCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/16.
//

import MessageKit
import UIKit

final class SystemMessageCell: UICollectionViewCell {
    
    private let viewModel = SystemMessageCellViewModel()
    private let welcomeMessageTextView = UITextView()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWelcomeMessageTextView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func configureWelcomeMessageTextView() {
        welcomeMessageTextView.isEditable = false
        welcomeMessageTextView.textAlignment = .left
        welcomeMessageTextView.isScrollEnabled = false
        welcomeMessageTextView.dataDetectorTypes = .link
        welcomeMessageTextView.backgroundColor = .clear
        welcomeMessageTextView.attributedText = viewModel.createAttributedString()
        welcomeMessageTextView.linkTextAttributes = [
            .foregroundColor: UIColor.blueGrayFont
        ]
    }
    
    private func configureLayout() {
        contentView.addSubview(welcomeMessageTextView)
        
        welcomeMessageTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            welcomeMessageTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            welcomeMessageTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            welcomeMessageTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            welcomeMessageTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}
