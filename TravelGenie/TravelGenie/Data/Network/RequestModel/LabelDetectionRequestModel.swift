//
//  LabelDetectionRequestModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation

struct LabelDetectionRequestModel: Codable {
    let requests: [Request]
}

struct Request: Codable {
    let image: Image
    let features: [Feature]
}

struct Feature: Codable {
    let maxResults: Int
    let type: String
    
    init() {
        self.maxResults = 10
        self.type = "LABEL_DETECTION"
    }
}

struct Image: Codable {
    let content: String
}
