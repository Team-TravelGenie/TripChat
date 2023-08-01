//
//  VisionLabelAPI.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation
import Moya

enum GoogleVisionLabelDetectionAPI {
    case labelDetection(GoogleVisionRequestModel)
}

extension GoogleVisionLabelDetectionAPI: DecodableTargetType {
    typealias ResultType = LabelDetectionDTO
    
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
        case .labelDetection(let labelDectectionRequestModel):
            return .requestCompositeParameters(
                bodyParameters: labelDectectionRequestModel.toDictionary(),
                bodyEncoding: JSONEncoding(options: .prettyPrinted),
                urlParameters: ["key": SecretStorage.GoogleVisionAPIKey])
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
