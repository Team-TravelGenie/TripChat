//
//  ButtonCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/16.
//

import UIKit

protocol UploadButtonCellDelegate: AnyObject {
    func didTapImageUploadButton()
}

final class UploadButtonCell: UICollectionViewCell {
    enum Constant {
        static let buttonText = "이미지 업로드"
    }
    
    weak var delegate: UploadButtonCellDelegate?
    
    private let uploadButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constant.buttonText, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .primary
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButtonAction() {
        let buttonAction = UIAction { [weak self] _ in
            self?.delegate?.didTapImageUploadButton()
        }
        
        uploadButton.addAction(buttonAction, for: .touchUpInside)
    }
    
    private func configureLayout() {
        contentView.addSubview(uploadButton)
        
        NSLayoutConstraint.activate([
            uploadButton.widthAnchor.constraint(equalToConstant: 351),
            uploadButton.heightAnchor.constraint(equalToConstant: 58),
            uploadButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            uploadButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
