//
//  VisionResultProcessor.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/30.
//

import Foundation

struct VisionResults {
    var keywords: [Keyword]
    var landmarks: [Landmark]
}

final class VisionResultProcessor {
    
    private var visionResults = VisionResults(keywords: [], landmarks: [])
    
    func setKeywords(_ keywords: [Keyword]) {
        keywords.forEach {
            visionResults.keywords.append($0)
        }
    }
    
    func setLandmarks(_ landmarks: [Landmark]) {
        landmarks.forEach {
            visionResults.landmarks.append($0)
        }
    }
}
