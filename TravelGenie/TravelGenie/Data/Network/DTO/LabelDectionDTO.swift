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
        let mid, description: String
        let score, topicality: Double
    }
}

extension LabelDetectionDTO {
    func mapToLabel(annotation: LabelDetectionDTO.Response.LabelAnnotation) -> Keyword {
        return Keyword(
            name: annotation.description,
            confidence: annotation.score)
    }
    
    func mapToDetectedImageLabel(from response: LabelDetectionDTO) -> DetectedImageLabel {
        let allAnnotations = response.responses.flatMap { $0.labelAnnotations }
        let labels = allAnnotations.map(mapToLabel)
        
        return DetectedImageLabel(labels: labels)
    }
}
