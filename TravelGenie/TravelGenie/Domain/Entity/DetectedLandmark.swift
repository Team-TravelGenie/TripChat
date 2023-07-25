//
//  DetectedLandmark.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/26.
//

import Foundation

struct DetectedLandmark {
    let landmarks: [Landmark]
}

struct Landmark {
    let place: String
    let confidence: Double
}
