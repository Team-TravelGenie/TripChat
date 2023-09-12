//
//  LoadingResponseCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/07.
//

import UIKit
import Lottie

final class LoadingResponseCell: UICollectionViewCell {
    
    private let avatarView = CircleIconView()
        .backgroundColor(.white)
        .size(40)
        .iconImage(imageName: DesignAssetName.chatAvatarImage, size: 32)
    
    private let animationView = LottieAnimationView(name: "loadingChat")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAnimationView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAnimationView() {
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
    }
    
    private func configureHierarchy() {
        [avatarView, animationView]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
        ])
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            animationView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            animationView.widthAnchor.constraint(equalToConstant: 68),
            animationView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
}
