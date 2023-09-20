//
//  SystemMessageViewModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/19.
//

import Foundation

final class SystemMessageCellViewModel {
    private enum Constant {
        static let systemMessageText = """
        입력 데이터는 OpenAI의 데이터 사용 정책, Google API의 서비스이용약관, Google API 사용자 데이터 정책, NAVER Developers 운영 정책에따라 관리됩니다.이 서비스는 초기버전으로 AI 답변의 신뢰성과 사용 시 생기는 문제에 책임을 지지 않으며 사정에 따라 사전 안내없이 중단 할 수 있습니다.개인 정보를 입력하지 않도록 유의해 주세요.
        """
    }
    
    private let hyperlinks: [Hyperlink] = [
        Hyperlink(type: .openAIPolicy),
        Hyperlink(type: .googleAPITerms),
        Hyperlink(type: .googleAPIPrivacyPolicy),
        Hyperlink(type: .naverDeveloperTerms)
    ]
    
    func createAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString()
            .hyperlinkText(Constant.systemMessageText, hyperlinks: hyperlinks, font: .captionRegular, color: .blueGrayFont)
    }
}
