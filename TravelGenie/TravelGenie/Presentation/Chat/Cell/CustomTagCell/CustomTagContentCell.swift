//
//  CustomTagContentCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/18.
//

import UIKit
import MessageKit

final class CustomTagContentCell: UICollectionViewCell {
    var tagList: [Tag] = [] {
        didSet {
            tagCollectionView.reloadData()
        }
    }
    
    private let avatarView = AvatarView()
    private let messageContainerView = UIView()
    private let tagMessageLabel = UILabel()
    private let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let submitKeywordButton = UIButton()
    private var messageContainerHeightLayoutConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        with message: MessageType)
    {
        if case .custom(let tagItem) = message.kind {
            guard let tagItem = tagItem as? TagItem else { return }
            
            tagList = tagItem.tags
        }
    }
    
    private func configureSubviews() {
        configureAvatarView()
        configureMessageContainerView()
        configureTagMessageLabel()
        configureTagCollectionView()
        configureSubmitButton()
    }
    
    private func configureAvatarView() {
        let avatarImage = UIImage(named: "chat")
        let avatar = Avatar(image: avatarImage)
        avatarView.set(avatar: avatar)
        avatarView.backgroundColor = .white
    }
    
    private func configureMessageContainerView() {
        messageContainerView.backgroundColor = .blueGrayBackground2
        messageContainerView.layer.cornerRadius = 20
        messageContainerView.clipsToBounds = true
        messageContainerView.layer.masksToBounds = true
    }
    
    private func configureTagMessageLabel() {
        let messageLabel = "키워드를 선택해주세요!"
        
        tagMessageLabel.attributedText = NSMutableAttributedString()
            .text(messageLabel, font: .bodyRegular, color: .black)
    }
    
    private func configureTagCollectionView() {
        tagCollectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        tagCollectionView.backgroundColor = .blueGrayBackground2
        tagCollectionView.isScrollEnabled = false
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.register(
            TagCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TagCollectionHeaderView.identifier)
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSubmitButton() {
        let titleLabel = NSMutableAttributedString()
            .text("키워드 보내기", font: .bodyRegular, color: .black)
        
        submitKeywordButton.setAttributedTitle(titleLabel, for: .normal)
        submitKeywordButton.layer.cornerRadius = 12
        submitKeywordButton.backgroundColor = .blueGrayBackground3
        submitKeywordButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureHierarchy() {
        [tagMessageLabel, tagCollectionView, submitKeywordButton]
            .forEach { messageContainerView.addSubview($0) }
        [avatarView, messageContainerView]
            .forEach { contentView.addSubview($0) }

    }
    
    private func configureLayout() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor)
        ])
        
        let defaultHeightValue: CGFloat = 500
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageContainerView.topAnchor.constraint(equalTo: avatarView.topAnchor),
            messageContainerView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            messageContainerView.widthAnchor.constraint(equalToConstant: 244)
        ])
        messageContainerHeightLayoutConstraint = messageContainerView.heightAnchor.constraint(equalToConstant: defaultHeightValue)
        messageContainerHeightLayoutConstraint?.isActive = true
        
        tagMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagMessageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 12),
            tagMessageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 20)
        ])

        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagCollectionView.topAnchor.constraint(equalTo: tagMessageLabel.bottomAnchor, constant: 12),
            tagCollectionView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 20),
            tagCollectionView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -20),
        ])
        
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitKeywordButton.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor, constant: 12),
            submitKeywordButton.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 20),
            submitKeywordButton.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -20),
            submitKeywordButton.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -12)
        ])
    }
}

extension CustomTagContentCell: UICollectionViewDataSource {
    fileprivate enum Section: Int {
        case location
        case theme
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return .zero }
        
        switch section {
        case .location:
            return 2
        case .theme:
            return tagList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCollectionViewCell.identifier,
            for: indexPath) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .location:
                let defaultTag = [
                    Tag(text: "국내"),
                    Tag(text: "해외")
                ]
                cell.configure(tag: defaultTag[indexPath.item])
            case .theme:
                cell.configure(tag: tagList[indexPath.item])
            }
        }

        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath)
        -> UICollectionReusableView
    {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TagCollectionHeaderView.identifier,
            for: indexPath) as? TagCollectionHeaderView else {
            return UICollectionReusableView()
        }
        
        let headerText: [String] = [
            "✈️지역",
            "⛵️테마"
        ]
        
        header.configure(text: headerText[indexPath.section])
            
        return header
    }
}

extension CustomTagContentCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize
    {
        let numberOfCharactersInTag = tagList[indexPath.item].text.count
        let defaultHeight: CGFloat = 47 // 고정높이
        let defaultWidth: CGFloat = 48 // 비어있는 태그의 tagCell의 width
        let additionalWidthForOneCharacterSize: CGFloat = 13.0
        
        let cellWidth = defaultWidth + CGFloat(numberOfCharactersInTag) * additionalWidthForOneCharacterSize

        return CGSize(width: cellWidth, height: defaultHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int)
        -> CGSize
    {
        return CGSize(width: 240, height: 23)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
        -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath)
    {
        updateCollectionViewHeight(tagCollectionView)
    }
    
    private func updateCollectionViewHeight(_ collectionView: UICollectionView) {
        guard let tagCollectionViewLayout = collectionView.collectionViewLayout as? LeftAlignedCollectionViewFlowLayout else {
            fatalError("flowLayout Error")
        }
        
        let messageLabelHeight = tagMessageLabel.frame.height
        let tagCollectionViewContentHeight = tagCollectionViewLayout.totalHeight
        let submitKeywordButtonHeight = submitKeywordButton.frame.height
        let totalContentHeight = tagCollectionViewContentHeight + messageLabelHeight + submitKeywordButtonHeight
        
        if messageContainerHeightLayoutConstraint?.constant != totalContentHeight {
            messageContainerHeightLayoutConstraint?.constant = totalContentHeight
        }
    }
}
