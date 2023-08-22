//
//  TagCollectionViewCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/18.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    
    private let tagButton: UIButton = {
       let button = UIButton()
        
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.blueGrayBackground.cgColor
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(tag: Tag) {
        let text = tag.value
        let title = NSMutableAttributedString()
            .text("#\(text)", font: .bodyRegular, color: .black)
        
        tagButton.setAttributedTitle(title, for: .normal)
    }
    
    private func configureLayout() {
        contentView.addSubview(tagButton)
        
        NSLayoutConstraint.activate([
            tagButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            tagButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tagButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
}
