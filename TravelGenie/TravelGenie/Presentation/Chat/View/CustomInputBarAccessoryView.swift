//
//  CustomInputBarAccessoryView.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/03.
//

import InputBarAccessoryView
import UIKit

final class CustomInputBarAccessoryView: InputBarAccessoryView {
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        backgroundColor = .white
        padding = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        configureLeftStackView()
    }
    
    private func configureLeftStackView() {
        leftStackView.alignment = .bottom
        setLeftStackViewWidthConstant(to: 36, animated: false)
        
        let galleryButton = InputBarButtonItem()
        let galleryButtonImage = UIImage(named: "images-regular")?.withRenderingMode(.alwaysTemplate)
        galleryButton.tintColor = .primary
        galleryButton.setImage(galleryButtonImage, for: .normal)
        galleryButton.setSize(CGSize(width: 36, height: 36), animated: false)
        setStackViewItems([galleryButton], forStack: .left, animated: false)
    }
}
