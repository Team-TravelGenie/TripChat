//
//  CircleIconView.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/25.
//

import UIKit

final class CircleIconView: UIView {

    private let iconImageView = UIImageView()
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func size(_ size: CGFloat) -> CircleIconView {
        layer.cornerRadius = size / 2
        layer.masksToBounds = true
        configureLayout(with: size)
        
        return self
    }
    
    func backgroundColor(_ color: UIColor) -> CircleIconView {
        layer.backgroundColor = color.cgColor
        
        return self
    }
    
    func iconImage(imageName: String, size: CGFloat) -> CircleIconView {
        configureIconImageView(with: imageName, size: size)
        
        return self
    }
    
    // MARK: Private
    
    private func configureHierarchy() {
        addSubview(iconImageView)
    }
    
    private func configureLayout(with size: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size),
            heightAnchor.constraint(equalToConstant: size),
        ])
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func configureIconImageView(with name: String, size: CGFloat) {
        let icon = UIImage(named: name)
        iconImageView.image = icon?.resize(width: size, height: size)
    }
}
