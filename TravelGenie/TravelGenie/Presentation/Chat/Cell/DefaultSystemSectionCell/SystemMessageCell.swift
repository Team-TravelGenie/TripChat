//
//  WelcomeMessageCell.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/16.
//

import MessageKit
import UIKit

final class SystemMessageCell: UICollectionViewCell {
    enum Constant {
        static let welcomeText = "입력 데이터는 OpenAI의 데이터 사용 정책과 XXX의 개인정보 처리방침에 따라 관리됩니다. 이 서비스는 초기버전으로 AI 답변의 신뢰성과 사용 시 생기는 문제에 책임을 지지 않으며 사정에 따라 사전 안내없이 중단 할 수 있습니다. 개인 정보를 입력하지 않도록 유의해 주세요."
    }
    
    private let welcomeMessageTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWelcomeMessageTextView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureWelcomeMessageTextView() {
        welcomeMessageTextView.backgroundColor = .blueGrayBackground
        welcomeMessageTextView.isEditable = false
        welcomeMessageTextView.textAlignment = .left
        welcomeMessageTextView.isScrollEnabled = false
        welcomeMessageTextView.attributedText = NSMutableAttributedString()
            .text(Constant.welcomeText, font: .captionRegular, color: .blueGrayFont)
    }
    
    private func configureLayout() {
        contentView.addSubview(welcomeMessageTextView)
        
        welcomeMessageTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            welcomeMessageTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            welcomeMessageTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            welcomeMessageTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            welcomeMessageTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}
