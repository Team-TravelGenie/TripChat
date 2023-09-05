//
//  UserFeedbackRequestModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/05.
//

struct UserFeedbackRequestModel: Encodable {
    let isPositive: Bool
    let content: String
    let selectedTags: [String]
    let recommendations: [String]
}
