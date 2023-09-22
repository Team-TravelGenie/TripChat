//
//  RecommendationItemCell.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import UIKit

final class RecommendationItemCell: UICollectionViewCell {
    
    static var identifier: String { return String(describing: self) }
    
    private let imageView = UIImageView()
    private let bottomView = UIView()
    private let descriptionTextView = UITextView()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 20
        backgroundColor = .white
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        descriptionTextView.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func configureContent(with item: RecommendationItem) {
        let text = NSMutableAttributedString()
            .text(item.country, font: .headline, color: .black)
            .text(" ", font: .headline, color: .black)
            .text("\(item.spotKorean) (\(item.spotEnglish))", font: .headline, color: .black)
        imageView.image = UIImage(data: item.image)
        descriptionTextView.attributedText = text
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        imageView.contentMode = .scaleAspectFill
        bottomView.backgroundColor = .white
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.backgroundColor = .white
    }
    
    private func configureHierarchy() {
        [imageView, bottomView].forEach { contentView.addSubview($0) }
        bottomView.addSubview(descriptionTextView)
    }
    
    private func configureLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 163),
        ])
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 84),
        ])
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
            descriptionTextView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
        ])
    }
}
