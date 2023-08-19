//
//  CustomTagContentCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/18.
//

import UIKit
import MessageKit

final class CustomTagContentCell: CustomMessageContentCell {
    var tagStorage: [Tag] = [] {
        didSet {
            tagCollectionView.reloadData()
        }
    }
    
    private let tagMessageLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var tagCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let submitKeywordButton: UIButton = {
        let button = UIButton(frame: .zero)
        
        button.setTitle("키워드 보내기", for: .normal)
        button.backgroundColor = .blueGrayBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tagMessageLabel.text = nil
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        [tagMessageLabel, tagCollectionView, submitKeywordButton]
            .forEach { messageContainerView.addSubview($0) }
        
        configureLayout()
    }
    
    override func configure(
        with message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView,
        dataSource: MessagesDataSource,
        and sizeCalculator: CustomLayoutSizeCalculator)
    {
        super.configure(
            with: message,
            at: indexPath,
            in: messagesCollectionView,
            dataSource: dataSource,
            and: sizeCalculator)
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            return
        }
        
        let calculator = sizeCalculator as? CustomTagLayoutSizeCalculator
        tagMessageLabel.frame = calculator?.messageLabelFrame(
            for: message,
            at: indexPath) ?? .zero
        
        if case .custom(let tagItem) = message.kind {
            guard let tagItem = tagItem as? TagItem else { return }
            let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
            let tags = tagItem.tags
            tagStorage = tags
            tagMessageLabel.attributedText = NSMutableAttributedString()
                .text(tagItem.text, font: .bodyRegular, color: .black)
            tagMessageLabel.textColor = textColor
        }
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            tagMessageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 12),
            tagMessageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            tagCollectionView.topAnchor.constraint(equalTo: tagMessageLabel.bottomAnchor, constant: 12),
            tagCollectionView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 20),
            tagCollectionView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -20),
        ])
        
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
            return 6 // 이건 구현방법을 좀 고민해봐야할 듯 합니다.
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCollectionViewCell.identifier,
            for: indexPath) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(data: tagStorage[indexPath.row].text)
        
        return cell
    }
}

extension CustomTagContentCell: UICollectionViewDelegate {
    
}
