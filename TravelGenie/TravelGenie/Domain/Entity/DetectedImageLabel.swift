//
//  DetectedImageLabel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation

struct DetectedImageLabel {
    let labels: [Keyword]
}

struct Keyword {
    let name: String
    let confidence: Double
}
