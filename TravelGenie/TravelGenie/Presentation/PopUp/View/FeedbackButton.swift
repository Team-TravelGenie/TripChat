//
//  FeedbackButton.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/25.
//

import UIKit

final class FeedbackButton: CustomButton {
    
    // MARK: Lifecycle
    
    init(
        normalBackgroundColor: UIColor,
        normalTintColor: UIColor,
        selectedBackgroundColor: UIColor,
        selectedTintColor: UIColor)
    {
        super.init(
            normalBackgroundColor: normalBackgroundColor,
            normalTintColor: normalTintColor,
            selectedBackgroundColor: selectedBackgroundColor,
            selectedTintColor: selectedTintColor)
        tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
