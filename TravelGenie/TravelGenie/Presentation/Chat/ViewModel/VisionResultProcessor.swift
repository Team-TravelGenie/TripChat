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
    
    func getTopSixResults() -> [Any] {
        var topSixResults: [Any] = []
        
        topSixResults.append(contentsOf: visionResults.landmarks)
        
        let sortedKeywords = visionResults.keywords.sorted(by: { $0.confidence > $1.confidence })
        let remainingSpace = 6 - topSixResults.count
        
        if remainingSpace > 0 {
            let remainingKeywords = Array(sortedKeywords.prefix(remainingSpace))
            
            topSixResults.append(contentsOf: remainingKeywords)
        }
        
        
        return topSixResults
    }
}
