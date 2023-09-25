//
//  ImagePickerCell.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/06.
//

import UIKit

final class ImagePickerCell: UICollectionViewCell {
    
    static var identifier: String { return String(describing: self) }
    
    var assetIdentifier = String()
    
    override var isSelected: Bool {
        didSet {
            countButton.isSelected = isSelected
        }
    }
    
    private let thumbnailImageView = UIImageView()
    private let countButton = CustomButton(
        normalBackgroundColor: .white,
        normalBorderColor: .blueGrayLine,
        normalBorderWidth: 1,
        selectedBackgroundColor: .primary)
        .size(24)
        .cornerRadius(12)
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        thumbnailImageView.image = nil
        countButton.titleLabel?.attributedText = nil
    }
    
    // MARK: Internal
    
    func setImage(image: UIImage?) {
        thumbnailImageView.image = image
    }
    
    func configureSelectedState(_ count: Int) {
        countButton.buttonTextSelected(count.description, font: .captionBold, color: .white)
    }
    
    func configureDeselectedState(_ count: Int) {
        countButton.buttonTextNormal(.init(), font: .captionBold, color: .clear)
    }
    
    func image() -> UIImage? {
        return thumbnailImageView.image
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        thumbnailImageView.contentMode = .scaleAspectFill
    }
    
    private func configureHierarchy() {
        [thumbnailImageView, countButton].forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        countButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            countButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
}
