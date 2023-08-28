//
//  ButtonCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/16.
//

import UIKit

final class UploadButtonCell: UICollectionViewCell {
    
    private enum Constant {
        static let buttonText = "이미지 업로드"
    }
    
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
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func configureButtonAction() {
        let buttonAction = UIAction { _ in
            NotificationCenter.default.post(name: .imageUploadButtonTapped, object: nil)
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
