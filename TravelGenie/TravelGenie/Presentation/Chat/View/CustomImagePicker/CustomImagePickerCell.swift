//
//  CustomImagePickerCell.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/06.
//

import UIKit

final class CustomImagePickerCell: UICollectionViewCell {
    
    static var identifier: String { return String(describing: self) }
    
    override var isSelected: Bool {
        didSet {
            countButton.isSelected = isSelected
        }
    }
    
    private let imageView = UIImageView()
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
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        imageView.image = nil
        countButton.titleLabel?.attributedText = nil
    }
    
    // MARK: Internal
    
    func setImage(image: UIImage?) {
        imageView.image = image
    }
    
    func configureSelectedState(_ count: Int) {
        countButton.buttonTextSelected(count.description, font: .captionBold, color: .white)
    }
    
    func configureDeselectedState(_ count: Int) {
        countButton.buttonTextNormal(.init(), font: .captionBold, color: .clear)
    }
    
    func image() -> UIImage? {
        return imageView.image
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        [imageView, countButton].forEach { contentView.addSubview($0) }
        imageView.contentMode = .scaleAspectFill
    }
    
    private func configureLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        countButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            countButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
}
