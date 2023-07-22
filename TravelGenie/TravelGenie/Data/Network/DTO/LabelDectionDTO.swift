//
//  LabelDectionDTO.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation

struct LabelDetectionResponse: Codable {
    let responses: [Response]
}

struct Response: Codable {
    let labelAnnotations: [LabelAnnotation]
}

struct LabelAnnotation: Codable {
    let mid, description: String
    let score, topicality: Double
}

extension LabelDetectionResponse {
    func mapToLabel(annotation: LabelAnnotation) -> Label {
        return Label(name: annotation.description,
                     confidence: annotation.score)
    }
    
    func mapToAIDectectedImageLabel(from response: LabelDetectionResponse) -> DetectedImageLabel {
        let allAnnotations = response.responses.flatMap { $0.labelAnnotations }
        let labels = allAnnotations.map(mapToLabel)
        
        return DetectedImageLabel(labels: labels)
    }
}
