//
//  ChatListCell.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import UIKit

final class ChatListCell: UITableViewCell {
    
    static var identifier: String { String(describing: self) }

    private let mainStackView = UIStackView()
    private let detailStackView = UIStackView()
    private let avatarImageView = UIImageView()
    private let dateLabel = UILabel()
    private let tagLabel = UILabel()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.attributedText = nil
        tagLabel.attributedText = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func configureContents(with item: Chat) {
        let tags: [String] = item.tags.tags.map { $0.value }
        let labelText = NSMutableAttributedString()
        let date = DateFormatter.formatter.string(from: item.createdAt)
        dateLabel.attributedText = NSMutableAttributedString()
            .text(date, font: .captionBold, color: .black)
        tags.forEach {
            labelText.append(NSMutableAttributedString()
                .text("#\($0) ", font: .captionRegular, color: .grayFont))}
        tagLabel.attributedText = labelText
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        contentView.backgroundColor = .white
        configureMainStackView()
        configureDetailStackView()
        configureAvatarImageView()
    }
    
    private func configureMainStackView() {
        mainStackView.spacing = 12
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
    }
    
    private func configureDetailStackView() {
        detailStackView.spacing = 2
        detailStackView.axis = .vertical
        detailStackView.alignment = .leading
    }
    
    private func configureAvatarImageView() {
        let image = UIImage(named: DesignAssetName.chatAvatarImage)
        avatarImageView.image = image
        avatarImageView.contentMode = .center
        avatarImageView.layer.cornerRadius = 26
        avatarImageView.layer.masksToBounds = true
        avatarImageView.backgroundColor = .blueGrayBackground
    }

    private func configureHierarchy() {
        contentView.addSubview(mainStackView)
        [avatarImageView, detailStackView].forEach { mainStackView.addArrangedSubview($0) }
        [dateLabel, tagLabel].forEach { detailStackView.addArrangedSubview($0) }
    }
    
    private func configureLayout() {
        let mainStackViewTopConstraint = mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        let mainStackViewBottomConstraint = mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        mainStackViewTopConstraint.priority = .defaultHigh
        mainStackViewBottomConstraint.priority = .defaultHigh
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackViewTopConstraint,
            mainStackViewBottomConstraint,
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 52),
            avatarImageView.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
}
