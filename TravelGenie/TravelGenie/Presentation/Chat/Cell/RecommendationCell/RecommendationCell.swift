//
//  RecommendationCell.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import MessageKit
import UIKit

// TODO: - 디자인가이드 확인 후 아바타뷰 컬렉션뷰 내부 셀로 처리할 것인지 결정
final class RecommendationCell: UICollectionViewCell {
    
    static var identifier: String { return String(describing: self) }
    
    private let viewModel = RecommendationCellViewModel()
    private let avatarView = AvatarView()
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
        configureAvatarView()
        configureRecommendationColletionView()
    }
    
    private func configureAvatarView() {
        let avatarImage = UIImage(named: "chat")
        let avatar = Avatar(image: avatarImage)
        avatarView.set(avatar: avatar)
        avatarView.backgroundColor = .white
    }
    
    private func configureRecommendationColletionView() {
        let layout = createRecommendationCollectionViewLayout()
        recommendationCollectionView.delegate = self
        recommendationCollectionView.dataSource = self
        recommendationCollectionView.backgroundColor = .clear
        recommendationCollectionView.collectionViewLayout = layout
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
        [avatarView, containerView].forEach { contentView.addSubview($0) }
        containerView.addSubview(recommendationCollectionView)
    }
    
    private func configureLayout() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendationItemCell.identifier,
            for: indexPath) as? RecommendationItemCell else { return UICollectionViewCell() }
        
        let item = viewModel.recommendations[indexPath.item]
        cell.configureContent(with: item)
        
        return cell
    }
}
