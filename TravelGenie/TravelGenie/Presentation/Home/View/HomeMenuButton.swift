//
//  HomeMenuButton.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/15.
//

import UIKit

final class HomeMenuButton: UIButton {
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = .grayBackground
        adjustsImageWhenHighlighted = false
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20 + 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
