//
//  HyperLink.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/19.
//

import Foundation

struct Hyperlink {
    enum HyperlinkType {
        case openAIPolicy
        case googleAPITerms
        case googleAPIPrivacyPolicy
        case naverDeveloperTerms
    }
    
    let type: HyperlinkType
    
    var text: String {
        switch type {
        case .openAIPolicy:
            return "OpenAI의 데이터 사용 정책"
        case .googleAPITerms:
            return "Google API의 서비스이용약관"
        case .googleAPIPrivacyPolicy:
            return "Google API 사용자 데이터 정책"
        case .naverDeveloperTerms:
            return "NAVER Developers 운영 정책"
        }
    }
    
    var url: String {
        switch type {
        case .openAIPolicy:
            return "https://www.openai.com/policies/"
        case .googleAPITerms:
            return "https://developers.google.com/terms"
        case .googleAPIPrivacyPolicy:
            return "https://developers.google.com/terms/api-services-user-data-policy"
        case .naverDeveloperTerms:
            return "https://developers.naver.com/products/intro/operation/operation.md"
        }
    }
}
