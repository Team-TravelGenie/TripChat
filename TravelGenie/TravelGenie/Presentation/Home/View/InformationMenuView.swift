//
//  InformationMenuView.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/16.
//

import UIKit

final class InformationMenuView: UIView {
    
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()

    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func setTitle(with value: String) {
        titleLabel.attributedText = NSMutableAttributedString()
            .body(value, color: .blueGrayFont, weight: .regular)
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        configureDisclosureIcon()
    }
    
    private func configureDisclosureIcon() {
        let icon: UIImage? = UIImage(systemName: "chevron.right")
        iconImageView.image = icon
        iconImageView.tintColor = .blueGrayFont
    }
    
    private func configureHierarchy() {
        [titleLabel, iconImageView].forEach { addSubview($0) }
    }
    
    private func configureLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
