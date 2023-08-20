//
//  RecommendationItemCell.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import UIKit

final class RecommendationItemCell: UICollectionViewCell {
    
    static var identifier: String { return String(describing: self) }
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
