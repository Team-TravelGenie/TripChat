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
        
        return convertTags(topSixResults)
    }
    
    private func convertTags(_ results: [Any]) -> [Tag] {
        var tags: [Tag] = []
        
        results.forEach {
            if let landmark = $0 as? Landmark {
                let tag = Tag(category: .theme, value: landmark.place)

                tags.append(tag)
            } else if let keyword = $0 as? Keyword {
                let tag = Tag(category: .theme, value: keyword.name)
                
                tags.append(tag)
            }
        }
        
        return tags
    }
}
