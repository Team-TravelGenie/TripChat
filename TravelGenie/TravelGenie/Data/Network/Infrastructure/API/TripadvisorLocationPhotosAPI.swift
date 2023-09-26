//
//  TripadvisorLocationPhotosAPI.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation
import Moya

enum TripadvisorLocationPhotosAPI {
    case locationPhotos(LocationPhotosRequestModel)
}

extension TripadvisorLocationPhotosAPI: DecodableTargetType {
    typealias ResultType = LocationPhotosDTO
    
    var baseURL: URL {
        return URL(string: "https://api.content.tripadvisor.com")!
    }
    
    var path: String {
        switch self {
        case .locationPhotos(let requestModel):
            return "/location/\(requestModel.locationId)/photos"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .locationPhotos(let requestModel):
            return .requestParameters(
                parameters: requestModel.toDictionary(),
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
