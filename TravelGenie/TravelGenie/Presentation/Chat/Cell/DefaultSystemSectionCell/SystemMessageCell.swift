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
        static let welcomeText = "입력 데이터는 OpenAI의 데이터 사용 정책과 XXX의 개인정보 처리방침에따라 관리됩니다.이 서비스는 초기버전으로 AI 답변의 신뢰성과 사용 시 생기는 문제에 책임을 지지 않으며 사정에 따라 사전 안내없이 중단 할 수 있습니다.개인 정보를 입력하지 않도록 유의해 주세요."
    }
    
    private let welcomeMessageLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.textColor = .blueGrayFont
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = Constant.welcomeText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureLayout() {
        contentView.addSubview(welcomeMessageLabel)
        
        NSLayoutConstraint.activate([
            welcomeMessageLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            welcomeMessageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
