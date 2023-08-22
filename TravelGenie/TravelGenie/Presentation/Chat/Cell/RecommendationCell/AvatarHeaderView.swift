//
//  AvatarHeaderView.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/21.
//

import UIKit

final class AvatarHeaderView: UICollectionReusableView {
    
    static var identifier: String { String(describing: self) }
    
    private let circleView = UIView()
    private let avatarImageView = UIImageView()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureCircleView()
        configureAvatarImageView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func configureCircleView() {
        circleView.backgroundColor = .white
        circleView.layer.cornerRadius = 20
        circleView.layer.masksToBounds = true
    }
    
    private func configureAvatarImageView() {
        let icon = UIImage(named: "chat")
        avatarImageView.backgroundColor = .clear
        avatarImageView.image = icon?.resize(width: 32, height: 32)
    }
    
    private func configureHierarchy() {
        [circleView, avatarImageView].forEach { addSubview($0) }
    }
    
    private func configureLayout() {
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: topAnchor),
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            circleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            circleView.widthAnchor.constraint(equalToConstant: 40),
            circleView.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
        ])
    }
}
