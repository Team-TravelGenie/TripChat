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

struct Response: Decodable {
    let labelAnnotations: [LabelAnnotation]
}

struct LabelAnnotation: Decodable {
    let mid, description: String
    let score, topicality: Double
}

extension LabelDetectionDTO {
    func mapToLabel(annotation: LabelAnnotation) -> Label {
        return Label(name: annotation.description,
                     confidence: annotation.score)
    }
    
    func mapToAIDectectedImageLabel(from response: LabelDetectionDTO) -> DetectedImageLabel {
        let allAnnotations = response.responses.flatMap { $0.labelAnnotations }
        let labels = allAnnotations.map(mapToLabel)
        
        return DetectedImageLabel(labels: labels)
    }
}
