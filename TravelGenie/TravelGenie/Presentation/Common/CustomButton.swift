//
//  CustomButton.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/07.
//

import UIKit

final class CustomButton: UIButton {
    
    private let normalBackgroundColor: UIColor
    private let normalBorderColor: UIColor
    private let normalBorderWidth: CGFloat
    private let selectedBackgroundColor: UIColor
    private let selectedBorderColor: UIColor
    private let selectedBorderWidth: CGFloat
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? selectedBackgroundColor : normalBackgroundColor
            layer.borderColor = isSelected ? selectedBorderColor.cgColor : normalBorderColor.cgColor
            layer.borderWidth = isSelected ? selectedBorderWidth : normalBorderWidth
        }
    }

    // MARK: Lifecycle
    
    init(
        normalBackgroundColor: UIColor,
        normalBorderColor: UIColor = .clear,
        normalBorderWidth: CGFloat = .zero,
        selectedBackgroundColor: UIColor,
        selectedBorderColor: UIColor = .clear,
        selectedBorderWidth: CGFloat = .zero
    ) {
        self.normalBackgroundColor = normalBackgroundColor
        self.normalBorderColor = normalBorderColor
        self.normalBorderWidth = normalBorderWidth
        self.selectedBackgroundColor = selectedBackgroundColor
        self.selectedBorderColor = selectedBorderColor
        self.selectedBorderWidth = selectedBorderWidth
        super.init(frame: .zero)
        clipsToBounds = true
        backgroundColor = .clear
        adjustsImageWhenHighlighted = false
        layer.opacity = isEnabled ? 1 : 0.2
        backgroundColor = normalBackgroundColor
        layer.borderColor = normalBorderColor.cgColor
        layer.borderWidth = normalBorderWidth
    }
    
    convenience init(backgroundColor: UIColor) {
        self.init(normalBackgroundColor: backgroundColor, selectedBackgroundColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func size(_ size: CGFloat) -> CustomButton {
        configureLayout(with: size)
        
        return self
    }
    
    func cornerRadius(_ cornerRadius: CGFloat) -> CustomButton {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        
        return self
    }
    
    func tintColor(color: UIColor) -> CustomButton {
        imageView?.tintColor = color
        
        return self
    }
    
    func buttonTextNormal(_ text: String, font: Font, color: UIColor) {
        let attributedText = NSMutableAttributedString()
            .text(text, font: font, color: color)
        setAttributedTitle(attributedText, for: .normal)
    }
    
    func buttonTextSelected(_ text: String, font: Font, color: UIColor) {
        let attributedText = NSMutableAttributedString()
            .text(text, font: font, color: color)
        setAttributedTitle(attributedText, for: .selected)
    }
    
    func assetIconImage(name: String, size: CGFloat) -> CustomButton {
        let image = UIImage(named: name)?
            .resize(width: size, height: size)
            .withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
        
        return self
    }
    
    func systemIconImage(name: String, size: CGFloat) -> CustomButton {
        let image = UIImage(systemName: name)?
            .resize(width: size, height: size)
            .withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
        
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
}
