//
//  CopyToastView.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/10/04.
//

import UIKit

final class CopyToastView: UIView {
    
    private enum Design {
        static let displayDuration: TimeInterval = 3.0
        static let toastViewWidthProportionToParent: CGFloat = 0.9146
        static let toastViewHeightProportionToParent: CGFloat = 0.0714
    }
    
    private let messageLabel = UILabel()
    private let checkCircleImageView = UIImageView()

    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal
    
    func show(in parentView: UIView) {
        parentView.addSubview(self)

        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: Design.toastViewWidthProportionToParent),
            self.heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: Design.toastViewHeightProportionToParent),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -40),
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor)
        ])

        self.alpha = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + Design.displayDuration) {
            UIView.animate(withDuration: 0.3) {
                self.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
            }
        }
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        self.backgroundColor = .tertiary
        self.layer.borderColor = UIColor.primary.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 12.0
        
        messageLabel.attributedText = NSMutableAttributedString()
            .text("복사가 완료되었습니다.", font: .headline, color: .primary)
        
        checkCircleImageView.image = UIImage(named: "check-circle")
    }
    
    private func configureHierarchy() {
        [checkCircleImageView, messageLabel]
            .forEach { addSubview($0) }
    }
    
    private func configureLayout() {
        checkCircleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkCircleImageView.widthAnchor.constraint(equalToConstant: 25),
            checkCircleImageView.heightAnchor.constraint(equalToConstant: 25),
            checkCircleImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkCircleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: checkCircleImageView.trailingAnchor, constant: 8)
        ])
    }
}
