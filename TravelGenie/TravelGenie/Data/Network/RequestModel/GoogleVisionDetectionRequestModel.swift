//
//  LabelDetectionRequestModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation

enum RequestType: String, Encodable {
    case labelDetection = "LABEL_DETECTION"
    case landmarkDetection = "LANDMARK_DETECTION"
}

struct GoogleVisionDetectionRequestModel: Encodable {
    let requests: [Request]
    
    init(base64EncodedImageData: String, requestType: RequestType) {
        let content = Content(base64EncodedImageData: base64EncodedImageData)
        let feature = Feature(type: requestType)
        let request = Request(content: content, features: [feature])
        self.requests = [request]
    }
}

struct Request: Encodable {
    let content: Content
    let features: [Feature]
    
    enum CodingKeys: String, CodingKey {
        case content = "image"
        case features
    }
}

struct Feature: Encodable {
    let maxResults: Int
    let type: RequestType
    
    init(type: RequestType) {
        self.type = type
        self.maxResults = 10
    }
}

struct Content: Encodable {
    let base64EncodedImageData: String
    
    enum CodingKeys: String, CodingKey {
        case base64EncodedImageData = "content"
    }
}
