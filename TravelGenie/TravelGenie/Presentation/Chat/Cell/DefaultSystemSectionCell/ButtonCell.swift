//
//  ButtonCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/16.
//

import UIKit

protocol ButtonCellDelegate {
    func didTapButton(in cell: UICollectionViewCell)
}

class ButtonCell: UICollectionViewCell {
    enum Constant {
        static let buttonText = "이미지 업로드"
    }
    
    var delegate: ButtonCellDelegate?
    
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
            guard let self else { return }
            
            self.delegate?.didTapButton(in: self)
        }
        
        uploadButton.addAction(buttonAction, for: .touchUpInside)
    }
    
    private func configureLayout() {
        contentView.addSubview(uploadButton)
        
        NSLayoutConstraint.activate([
            uploadButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            uploadButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            uploadButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}