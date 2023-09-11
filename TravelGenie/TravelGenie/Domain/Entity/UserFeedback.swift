//
//  UserFeedback.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/26.
//

struct UserFeedback {
    let isPositive: Bool
    let content: String
    let selectedTags: [String]
    let recommendations: [String]
    
    init(
        isPositive: Bool,
        content: String,
        selectedTags: [String],
        recommendations: [String])
    {
        self.isPositive = isPositive
        self.content = content
        self.selectedTags = selectedTags
        self.recommendations = recommendations
    }
}
