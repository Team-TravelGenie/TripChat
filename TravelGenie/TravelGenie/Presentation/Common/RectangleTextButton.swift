//
//  RectangleTextButton.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/25.
//

import UIKit

final class RectangleTextButton: UIButton {
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        layer.masksToBounds = true
        adjustsImageWhenHighlighted = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func backgroundColor(_ color: UIColor) -> RectangleTextButton {
        backgroundColor = color
        
        return self
    }
    
    func borderColor(_ color: UIColor) -> RectangleTextButton {
        layer.borderColor = color.cgColor
        
        return self
    }
    
    func cornerRadius(_ radius: CGFloat) -> RectangleTextButton {
        layer.cornerRadius = 8
        
        return self
    }
    
    func borderWidth(_ width: CGFloat) -> RectangleTextButton {
        layer.borderWidth = width
        
        return self
    }
}
