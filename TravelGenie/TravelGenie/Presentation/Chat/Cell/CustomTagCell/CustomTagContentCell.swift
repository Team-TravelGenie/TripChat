//
//  CustomTagContentCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/18.
//

import UIKit
import MessageKit

final class CustomTagContentCell: CustomMessageContentCell {
    var tagStorage: [Tag] = []
    
    private let tagMessageLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var tagCollectionViewCell: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tagMessageLabel.text = nil
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        messageContainerView.addSubview(tagMessageLabel)
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
        
        let calculator = sizeCalculator as? CustomTextLayoutSizeCalculator
        tagMessageLabel.frame = calculator?.messageLabelFrame(
            for: message,
            at: indexPath) ?? .zero
        
        let textMessageKind = message.kind
        switch textMessageKind {
        case .custom(let tagItem):
            let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
            tagMessageLabel.text
            tagMessageLabel.textColor = textColor
        default:
            break
        }
    }
}

extension CustomTagContentCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagStorage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCollectionViewCell.identifier,
            for: indexPath) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(data: tagStorage[indexPath.row].tag)
        
        return cell
    }
}

extension CustomTagContentCell: UICollectionViewDelegate {
    
}
