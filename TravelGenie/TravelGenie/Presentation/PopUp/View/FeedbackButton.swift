//
//  FeedbackButton.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/25.
//

import UIKit

final class FeedbackButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            tintColor = isSelected ? .primary : .white
            backgroundColor = isSelected ? .tertiary : .blueGrayLine
        }
    }
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        tintColor = .white
        backgroundColor = .blueGrayLine
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func size(_ size: CGFloat) -> FeedbackButton {
        layer.masksToBounds = true
        layer.cornerRadius = size / 2
        configureLayout(with: size)
        
        return self
    }
    
    func image(name: String, size: CGFloat) -> FeedbackButton {
        configureButtonImage(with: name, size: size)
        
        return self
    }
    
    // MARK: Private
    
    private func configureLayout(with size: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size),
            heightAnchor.constraint(equalToConstant: size),
        ])
    }
    
    private func configureButtonImage(with imageName: String, size: Double) {
        let image = UIImage(named: imageName)?
            .resize(width: size, height: size)
            .withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
    }
}
