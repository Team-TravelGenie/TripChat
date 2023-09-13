//
//  CustomTagContentCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/18.
//

import UIKit
import MessageKit

protocol TagMessageSizeDelegate: AnyObject {
    func didUpdateTagMessageHeight(_ height: CGFloat)
}

final class CustomTagContentCell: UICollectionViewCell {
    
    weak var sizeDelegate: TagMessageSizeDelegate?
    
    private let viewModel = CustomTagContentCellViewModel()
    
    private let messageContentView = UIView()
    private let defaultMessageLabel = UILabel()
    private let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let avatarView = CircleIconView()
        .backgroundColor(.white)
        .size(40)
        .iconImage(imageName: "chat", size: 32)
    
    private let submitKeywordButton = RectangleTextButton()
        .cornerRadius(8)
        .backgroundColor(.blueGrayBackground3)
    
    private var messageContentViewHeightLayoutConstraint: NSLayoutConstraint?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func configure(with message: MessageType) {
        if case .custom(let tagItem) = message.kind {
            guard let tagItem = tagItem as? TagItem else { return }
            
            viewModel.insertTags(tags: tagItem.tags)
        }
    }
    
    func configureButtonsState(_ state: (Bool, Bool)) {
        viewModel.updateSubmitButtonState(state.0)
        tagCollectionView.isUserInteractionEnabled = state.1
    }
    
    // MARK: Private
    
    private func bind() {
        viewModel.didTapSubmitButton = { [weak self] state in
            DispatchQueue.main.async {
                self?.configureSubmitButtonStateAndAppearance(state)
            }
        }
    }
    
    private func configureSubmitButtonStateAndAppearance(_ state: Bool) {
        submitKeywordButton.isEnabled = state
        submitKeywordButton.backgroundColor = state ? .blueGrayBackground3 : .blueGrayBackground
        submitKeywordButton.layer.opacity = state ? 1 : 0.2
    }
    
    private func configureSubviews() {
        configureSubmitKeywordButton()
        configureTagCollectionView()
        configureMessageContentView()
        configureDefaultMessageLabel()
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
        submitKeywordButton.setAttributedTitle(titleText, for: .normal)
    }
    
    private func configureSubmitKeywordButtonAction() {
        let buttonAction = UIAction { [weak self] _ in
            guard let self,
                  let selectedList = self.viewModel.getSelectedTags() else {
                return
            }
            
            self.viewModel.submitSelectedTags(selectedList)
        }
        submitKeywordButton.addAction(buttonAction, for: .touchUpInside)
    }
    
    private func configureHierarchy() {
        [defaultMessageLabel, tagCollectionView, submitKeywordButton]
            .forEach { messageContentView.addSubview($0) }
        [avatarView, messageContentView]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
        ])
        
        let defaultHeightValue: CGFloat = 500
        messageContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageContentView.topAnchor.constraint(equalTo: avatarView.topAnchor),
            messageContentView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
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
            submitKeywordButton.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor),
            submitKeywordButton.leadingAnchor.constraint(equalTo: messageContentView.leadingAnchor, constant: 20),
            submitKeywordButton.trailingAnchor.constraint(equalTo: messageContentView.trailingAnchor, constant: -20),
            submitKeywordButton.heightAnchor.constraint(equalToConstant: 47),
            submitKeywordButton.bottomAnchor.constraint(equalTo: messageContentView.bottomAnchor, constant: -12)
        ])
    }
}

// MARK: UICollectionViewDataSource

extension CustomTagContentCell: UICollectionViewDataSource {
    fileprivate enum Section: Int {
        case location
        case theme
        case keyword
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return .zero }
        
        switch section {
        case .location:
            return viewModel.locationTags.count
        case .theme:
            return viewModel.themeTags.count
        case .keyword:
            return viewModel.keywordTags.count
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
                cell.configure(tag: viewModel.locationTags[indexPath.item])
            case .theme:
                cell.configure(tag: viewModel.themeTags[indexPath.item])
            case .keyword:
                cell.configure(tag: viewModel.keywordTags[indexPath.item])
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

// MARK: UICollectionViewDelegateFlowLayout

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
        return CGSize(width: 204, height: 23)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int)
        -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 4, left: 0, bottom: 12, right: 0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int)
        -> CGFloat
    {
        return 8
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath)
    {
        updateCollectionViewHeight()
    }
    
    private func updateCollectionViewHeight() {
        let totalContentHeight = totalContentHeight(tagCollectionView)
        
        // messageContainerHeightLayoutConstraint.constant가 contentsSize를 반영하지 않은 경우에만 업데이트
        if messageContentViewHeightLayoutConstraint?.constant != totalContentHeight {
            messageContentViewHeightLayoutConstraint?.constant = totalContentHeight
            sizeDelegate?.didUpdateTagMessageHeight(totalContentHeight)
        }
    }
    
    private func totalContentHeight(_ collectionView: UICollectionView) -> CGFloat {
        guard let tagCollectionViewLayout = collectionView.collectionViewLayout as? LeftAlignedCollectionViewFlowLayout else {
            fatalError("flowLayout Error")
        }
        
        let messageLabelHeight = defaultMessageLabel.frame.height
        let tagCollectionViewContentHeight = tagCollectionViewLayout.totalHeight
        let submitKeywordButtonHeight = submitKeywordButton.frame.height
        let accuracyLimit = 16.0
        
        return tagCollectionViewContentHeight + messageLabelHeight + submitKeywordButtonHeight - accuracyLimit
    }
}

// MARK: TagSelectionDelegate

extension CustomTagContentCell: TagSelectionDelegate {
    func tagDidSelect(withText value: String, isSelected: Bool) {
        viewModel.updateTagIsSelected(value: value, isSelected: isSelected)
    }
}
