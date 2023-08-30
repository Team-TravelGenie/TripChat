//
//  VisionResultProcessor.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/30.
//

import Foundation

struct VisionResults {
    var keywords: [Keyword]
    var landmarks: [Landmark]?
}

final class VisionResultProcessor {
    
    private var visionResults: VisionResults?
    
    func setKeywords(_ keywords: [Keyword]) {
        visionResults?.keywords = keywords
    }
    
    func setLandmarks(_ landmarks: [Landmark]) {
        visionResults?.landmarks = landmarks
    }
}
