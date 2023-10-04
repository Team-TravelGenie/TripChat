//
//  OpenAIRecommendation.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/27.
//

import Foundation

struct OpenAIRecommendation: Decodable {
    struct RecommendationItem: Decodable {
        let country: String
        let spotKorean: String
        let spotEnglish: String
    }
    
    let recommendationItems: [RecommendationItem]
}
