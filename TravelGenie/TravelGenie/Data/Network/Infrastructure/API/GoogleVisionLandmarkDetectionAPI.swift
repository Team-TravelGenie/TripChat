//
//  GoogleVisionLandmarkDetectionAPI.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/26.
//

import Foundation
import Moya

enum GoogleVisionLandmarkDetectionAPI {
    case landmarkDetection(GoogleVisionRequestModel)
}

extension GoogleVisionLandmarkDetectionAPI: DecodableTargetType {
    typealias ResultType = LandmarkDetectionDTO
    
    var baseURL: URL {
        return URL(string: "https://vision.googleapis.com")!
    }
    
    var path: String {
        return "/v1/images:annotate"
    }
    
    var method: Moya.Method {
        switch self {
        case .landmarkDetection:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .landmarkDetection(let googleVisionDetectionRequestModel):
            return .requestCompositeParameters(
                bodyParameters: googleVisionDetectionRequestModel.toDictionary(),
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
