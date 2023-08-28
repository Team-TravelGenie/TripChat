//
//  TagCollectionHeaderView.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/20.
//

import UIKit

class TagCollectionHeaderView: UICollectionReusableView {
    static var identifier: String { return String(describing: self) }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal

    func configure(text: String) {
        titleLabel.attributedText = NSMutableAttributedString()
            .text(text, font: .bodyRegular, color: .black)
    }
    
    // MARK: Private
    
    private func configureLayout() {
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
