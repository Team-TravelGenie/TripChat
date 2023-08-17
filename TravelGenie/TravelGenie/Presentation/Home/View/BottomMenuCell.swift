//
//  BottomMenuCell.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/17.
//

import UIKit

final class BottomMenuCell: UITableViewCell {
    
    static var identifier: String { return String(describing: self) }
    
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
    
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
            .text(value, font: .bodyRegular, color: .blueGrayFont)
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
        [titleLabel, iconImageView].forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
