//
//  LoadingResponseCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/07.
//

import UIKit
import Lottie

final class LoadingResponseCell: UICollectionViewCell {
    
    private let animationView = LottieAnimationView(name: "iHi4RYS3KJ-2")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAnimationView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAnimationView() {
        animationView.play()
    }
    
}
