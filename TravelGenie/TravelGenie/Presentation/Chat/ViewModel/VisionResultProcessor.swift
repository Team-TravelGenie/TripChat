//
//  VisionResultProcessor.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/30.
//

import Foundation

final class VisionResultProcessor {
    
    private struct VisionResults {
        var keywords: [Keyword]
        var landmarks: [Landmark]
    }
    
    private var visionResults = VisionResults(keywords: [], landmarks: [])
    
    func addKeywords(_ keywords: [Keyword]) {
        visionResults.keywords.append(contentsOf: keywords)
    }
    
    func addLandmarks(_ landmarks: [Landmark]) {
        visionResults.landmarks.append(contentsOf: landmarks)
    }
    
    func getTopSixResults() -> [Tag] {
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
        return results.compactMap {
            if let landmark = $0 as? Landmark {
                return Tag(category: .theme, value: landmark.place)
            } else if let keyword = $0 as? Keyword {
                return Tag(category: .theme, value: keyword.name)
            }
            
            return nil
        }
    }
}
