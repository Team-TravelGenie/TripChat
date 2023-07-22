//
//  DetectedImageLabel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation

struct DetectedImageLabel {
    let labels: [Label]
}

struct Label {
    let name: String
    let confidence: Double
}
