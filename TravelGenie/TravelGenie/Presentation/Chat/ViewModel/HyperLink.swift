//
//  HyperLink.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/19.
//

import Foundation

struct HyperLink {
    enum HyperLinkType {
        case OpenAIPolicy
        case GoogleAPITerms
        case GoogleAPIPrivacyPolicy
        case NaverDeveloperTerms
    }
    
    let type: HyperLinkType
    
    var text: String {
        switch type {
        case .OpenAIPolicy:
            return "OpenAI의 데이터 사용 정책"
        case .GoogleAPITerms:
            return "Google API의 서비스이용약관"
        case .GoogleAPIPrivacyPolicy:
            return "Google API 사용자 데이터 정책"
        case .NaverDeveloperTerms:
            return "NAVER Developers 운영 정책"
        }
    }
    
    var url: String {
        switch type {
        case .OpenAIPolicy:
            return "https://www.openai.com/policies/"
        case .GoogleAPITerms:
            return "https://www.google.com/terms"
        case .GoogleAPIPrivacyPolicy:
            return "https://www.google.com/policies/privacy"
        case .NaverDeveloperTerms:
            return "https://developers.naver.com/terms"
        }
    }
}
