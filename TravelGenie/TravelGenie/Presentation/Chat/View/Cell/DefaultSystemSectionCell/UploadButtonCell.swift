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
    
    private let uploadButton = RectangleTextButton()
        .cornerRadius(12)
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUploadButton()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButtonState(state: Bool) {
        uploadButton.isEnabled = state
        
        state ? uploadButton.backgroundColor(.primary) : uploadButton.backgroundColor(.blueGrayLine)
    }
    
    // MARK: Private
    
    private func configureUploadButton() {
        let buttonTitle = NSMutableAttributedString()
            .text(Constant.buttonText, font: .headline, color: .white)
        uploadButton.setAttributedTitle(buttonTitle, for: .normal)
        configureButtonAction()
    }
    
    private func configureButtonAction() {
        let buttonAction = UIAction { _ in
            NotificationCenter.default.post(name: .imageUploadButtonTapped, object: nil)
        }
        
        uploadButton.addAction(buttonAction, for: .touchUpInside)
    }
    
    private func configureLayout() {
        contentView.addSubview(uploadButton)
        
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uploadButton.widthAnchor.constraint(equalToConstant: 351),
            uploadButton.heightAnchor.constraint(equalToConstant: 58),
            uploadButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            uploadButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
