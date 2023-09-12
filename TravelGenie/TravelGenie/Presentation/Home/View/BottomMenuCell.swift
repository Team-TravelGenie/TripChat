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
    private let disclosureIconImageView = UIImageView()
    
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
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
        disclosureIconImageView.image = icon
        disclosureIconImageView.tintColor = .blueGrayFont
    }
    
    private func configureHierarchy() {
        [titleLabel, disclosureIconImageView].forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        disclosureIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            disclosureIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            disclosureIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            disclosureIconImageView.widthAnchor.constraint(equalToConstant: 12),
            disclosureIconImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
