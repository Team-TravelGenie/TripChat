//
//  LandmarkDetectionDTO.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/26.
//

import Foundation

struct LandmarkDetectionDTO: Decodable {
    let responses: [Response]
}

extension LandmarkDetectionDTO {
    struct Response: Decodable {
        let landmarkAnnotations: [LandmarkAnnotation]
    }
}

extension LandmarkDetectionDTO.Response {
    struct LandmarkAnnotation: Decodable {
        let mid: String
        let description: String
        let score: Double
        let boundingPoly: BoundingPoly
        let locations: [Location]
    }
}

extension LandmarkDetectionDTO.Response.LandmarkAnnotation {
    struct BoundingPoly: Decodable {
        let vertices: [Vertex]
    }
    
    struct Location: Decodable {
        let latLng: LatLng
    }
}

extension LandmarkDetectionDTO.Response.LandmarkAnnotation.BoundingPoly {
    struct Vertex: Decodable {
        let x: Int?
        let y: Int?
    }
}

extension LandmarkDetectionDTO.Response.LandmarkAnnotation.Location {
    struct LatLng: Decodable {
        let latitude: Double
        let longitude: Double
    }
}

// MARK: Mapping
extension LandmarkDetectionDTO {
    private func mapToLandmark(annotation: LandmarkDetectionDTO.Response.LandmarkAnnotation) -> Landmark {
        return Landmark(
            place: annotation.description,
            confidence: annotation.score)
    }
    
    func mapToDetectedLandmark() -> DetectedLandmark {
        let allAnnotation = self.responses.flatMap { $0.landmarkAnnotations }
        let landmarks = allAnnotation.map(mapToLandmark)
        
        return DetectedLandmark(landmarks: landmarks)
    }
}
