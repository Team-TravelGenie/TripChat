//
//  CustomTagContentCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/18.
//

import UIKit
import MessageKit

protocol TagSubmissionDelegate: AnyObject {
    func submitSelectedTags(_ selectedTags: [MockTag])
}

final class CustomTagContentCell: UICollectionViewCell {
    weak var delegate: TagSubmissionDelegate?
    
    private let viewModel = CustomTagContentCellViewModel()
    
    private let tagContentAvatarView = AvatarView()
    private let messageContentView = UIView()
    private let defaultMessageLabel = UILabel()
    private let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let submitKeywordButton = UIButton()
    private var messageContentViewHeightLayoutConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with message: MessageType) {
        if case .custom(let tagItem) = message.kind {
            guard let tagItem = tagItem as? MockTagItem else { return }
            
            viewModel.insertTags(tags: tagItem.tags)
        }
    }
    
    private func configureSubviews() {
        configureSubmitKeywordButton()
        configureTagCollectionView()
        configureMessageContentView()
        configureDefaultMessageLabel()
        configureTagContentAvatarView()
    }
    
    private func configureTagContentAvatarView() {
        let avatarImage = UIImage(named: "chat")
        let avatar = Avatar(image: avatarImage)
        tagContentAvatarView.set(avatar: avatar)
        tagContentAvatarView.backgroundColor = .white
    }
    
    private func configureMessageContentView() {
        messageContentView.clipsToBounds = true
        messageContentView.layer.cornerRadius = 20
        messageContentView.layer.masksToBounds = true
        messageContentView.backgroundColor = .blueGrayBackground2
    }
    
    private func configureDefaultMessageLabel() {
        let messageLabel = "키워드를 선택해주세요!"
        
        defaultMessageLabel.attributedText = NSMutableAttributedString()
            .text(messageLabel, font: .bodyRegular, color: .black)
    }
    
    private func configureTagCollectionView() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.isScrollEnabled = false
        tagCollectionView.backgroundColor = .blueGrayBackground2
        tagCollectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        tagCollectionView.register(
            TagCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TagCollectionHeaderView.identifier)
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSubmitKeywordButton() {
        let titleText = NSMutableAttributedString()
            .text("키워드 보내기", font: .bodyRegular, color: .black)
        
        configureSubmitKeywordButtonAction()
        submitKeywordButton.layer.cornerRadius = 12
        submitKeywordButton.backgroundColor = .blueGrayBackground3
        submitKeywordButton.setAttributedTitle(titleText, for: .normal)
    }
    
    private func configureSubmitKeywordButtonAction() {
        let buttonAction = UIAction { [weak self] _ in
            guard let self,
                  let selectedList = self.viewModel.getSelectedTags() else {
                return
            }
            
            self.delegate?.submitSelectedTags(selectedList)
        }
        
        submitKeywordButton.addAction(buttonAction, for: .touchUpInside)
    }
    
    private func configureHierarchy() {
        [defaultMessageLabel, tagCollectionView, submitKeywordButton]
            .forEach { messageContentView.addSubview($0) }
        [tagContentAvatarView, messageContentView]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        tagContentAvatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagContentAvatarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tagContentAvatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagContentAvatarView.widthAnchor.constraint(equalToConstant: 40),
            tagContentAvatarView.heightAnchor.constraint(equalTo: tagContentAvatarView.widthAnchor)
        ])
        
        let defaultHeightValue: CGFloat = 500
        messageContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageContentView.topAnchor.constraint(equalTo: tagContentAvatarView.topAnchor),
            messageContentView.leadingAnchor.constraint(equalTo: tagContentAvatarView.trailingAnchor, constant: 8),
            messageContentView.widthAnchor.constraint(equalToConstant: 244)
        ])
        messageContentViewHeightLayoutConstraint = messageContentView.heightAnchor.constraint(equalToConstant: defaultHeightValue)
        messageContentViewHeightLayoutConstraint?.isActive = true
        
        defaultMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            defaultMessageLabel.topAnchor.constraint(equalTo: messageContentView.topAnchor, constant: 12),
            defaultMessageLabel.leadingAnchor.constraint(equalTo: messageContentView.leadingAnchor, constant: 20)
        ])

        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagCollectionView.topAnchor.constraint(equalTo: defaultMessageLabel.bottomAnchor, constant: 12),
            tagCollectionView.leadingAnchor.constraint(equalTo: messageContentView.leadingAnchor, constant: 20),
            tagCollectionView.trailingAnchor.constraint(equalTo: messageContentView.trailingAnchor, constant: -20),
        ])
        
        submitKeywordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitKeywordButton.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor, constant: 12),
            submitKeywordButton.leadingAnchor.constraint(equalTo: messageContentView.leadingAnchor, constant: 20),
            submitKeywordButton.trailingAnchor.constraint(equalTo: messageContentView.trailingAnchor, constant: -20),
            submitKeywordButton.bottomAnchor.constraint(equalTo: messageContentView.bottomAnchor, constant: -12)
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
            return viewModel.locationTagListCount
        case .theme:
            return viewModel.themeTagListCount
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
                cell.configure(tag: viewModel.locationTagList[indexPath.item])
            case .theme:
                cell.configure(tag: viewModel.themeTagList[indexPath.item])
            }
        }

        cell.delegate = self
        
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
        
        header.configure(text: viewModel.sectionsHeaderTexts[indexPath.section])
            
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
        viewModel.cellSizeForSection(indexPath: indexPath)
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
        
        let messageLabelHeight = defaultMessageLabel.frame.height
        let tagCollectionViewContentHeight = tagCollectionViewLayout.totalHeight
        let submitKeywordButtonHeight = submitKeywordButton.frame.height
        let insetPadding: CGFloat = 20
        let totalContentHeight = tagCollectionViewContentHeight + messageLabelHeight + submitKeywordButtonHeight + insetPadding
        
        // messageContainerHeightLayoutConstraint.constant가 contentsSize를 반영하지 않은 경우에만 업데이트
        if messageContentViewHeightLayoutConstraint?.constant != totalContentHeight {
            messageContentViewHeightLayoutConstraint?.constant = totalContentHeight
        }
    }
}

extension CustomTagContentCell: TagSelectionDelegate {
    func tagDidSelect(withText value: String, isSelected: Bool) {
        viewModel.updateTagIsSelected(value: value, isSelected: isSelected)
    }
}
