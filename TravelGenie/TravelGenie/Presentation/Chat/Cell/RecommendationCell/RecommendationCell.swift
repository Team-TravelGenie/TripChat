//
//  RecommendationCell.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import MessageKit
import UIKit

final class RecommendationCell: UICollectionViewCell {
    
    static var identifier: String { return String(describing: self) }
    
    private let viewModel = RecommendationCellViewModel()
    private let containerView = UIView()
    private let recommendationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func configure(with message: MessageType) {
        if case let .custom(items) = message.kind {
            guard let items = items as? [RecommendationItem] else { return }
            
            viewModel.recommendations = items
        }
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        configureRecommendationColletionView()
    }
    
    private func configureRecommendationColletionView() {
        let layout = createRecommendationCollectionViewLayout()
        recommendationCollectionView.delegate = self
        recommendationCollectionView.dataSource = self
        recommendationCollectionView.backgroundColor = .clear
        recommendationCollectionView.collectionViewLayout = layout
        recommendationCollectionView.register(
            AvatarHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AvatarHeaderView.identifier)
        recommendationCollectionView.register(
            RecommendationItemCell.self,
            forCellWithReuseIdentifier: RecommendationItemCell.identifier)
    }
    
    private func createRecommendationCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let itemSize = CGSize(width: 244, height: 247)
        layout.itemSize = itemSize
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        
        return layout
    }
    
    private func configureHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(recommendationCollectionView)
    }
    
    private func configureLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 247),
        ])
        
        recommendationCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recommendationCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            recommendationCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            recommendationCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            recommendationCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
}

// MARK: UICollectionViewDelegate & UICollectionViewDataSource

extension RecommendationCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int)
        -> Int
    {
        return viewModel.recommendations.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendationItemCell.identifier,
            for: indexPath) as? RecommendationItemCell else { return UICollectionViewCell() }
        
        let item = viewModel.recommendations[indexPath.item]
        cell.configureContent(with: item)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath)
        -> UICollectionReusableView
    {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AvatarHeaderView.identifier,
            for: indexPath)
        
        return header
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension RecommendationCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int)
        -> CGSize
    {
        return CGSizeMake(12 + 40 + 8, 40)
    }
}
