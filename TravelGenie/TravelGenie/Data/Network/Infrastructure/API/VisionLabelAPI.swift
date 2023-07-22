//
//  VisionLabelAPI.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation
import Moya

enum VisionLabelAPI {
    case labelDetection
}

extension VisionLabelAPI: DecodableTargetType {
    typealias ResultType = LabelDetectionResponse
    
    var baseURL: URL {
        return URL(string: "https://vision.googleapis.com")!
    }
    
    var path: String {
        switch self {
        case .labelDetection:
            return "/v1/images:annotate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .labelDetection:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .labelDetection:
            let bodyParameters: [String: Any] = [
                "requests": [
                    "image": ["content": "https://i.pinimg.com/originals/a1/ac/b3/a1acb395f6cc80e039ddd9758926df71.jpg"],
                    "features": [
                        ["maxResults": 10, "type": "LABEL_DETECTION"]
                    ]
                ]
            ]
            
            return .requestCompositeParameters(
                bodyParameters: bodyParameters,
                bodyEncoding: URLEncoding.queryString,
                urlParameters: ["key": SecretStorage().apiKey]
            )
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
