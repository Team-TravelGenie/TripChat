//
//  LabelDectionDTO.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation

struct LabelDetectionDTO: Decodable {
    let responses: [Response]
}

extension LabelDetectionDTO {
    struct Response: Decodable {
        let labelAnnotations: [LabelAnnotation]
    }
}

extension LabelDetectionDTO.Response {
    struct LabelAnnotation: Decodable {
        let mid: String
        let description: String
        let score: Double
        let topicality: Double
    }
}

// MARK: Mapping
extension LabelDetectionDTO {
    private func mapToKeyword(annotation: LabelDetectionDTO.Response.LabelAnnotation) -> Keyword {
        return Keyword(
            name: annotation.description,
            confidence: annotation.score)
    }
    
    func mapToDetectedImageLabel() -> DetectedImageLabel {
        let allAnnotations = self.responses.flatMap { $0.labelAnnotations }
        let labels = allAnnotations.map(mapToKeyword)
        
        return DetectedImageLabel(labels: labels)
    }
}
