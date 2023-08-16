//
//  LineView.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/16.
//

import UIKit

final class LineView: UIView {
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func setLineWith(color: UIColor, weight: CGFloat) {
        backgroundColor = color
        heightAnchor.constraint(equalToConstant: weight).isActive = true
    }
}
