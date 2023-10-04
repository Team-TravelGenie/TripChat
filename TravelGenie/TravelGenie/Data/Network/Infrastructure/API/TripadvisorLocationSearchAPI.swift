//
//  TripadvisorLocationSearchAPI.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation
import Moya

enum TripadvisorLocationSearchAPI {
    case locationSearch(LocationSearchRequestModel)
}

extension TripadvisorLocationSearchAPI: DecodableTargetType {
    typealias ResultType = LocationSearchDTO
    
    var baseURL: URL {
        return URL(string: "https://api.content.tripadvisor.com")!
    }
    
    var path: String {
        return "/api/v1/location/search"
    }
    
    var method: Moya.Method {
        switch self {
        case .locationSearch:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .locationSearch(let requestModel):
            return .requestParameters(
                parameters: requestModel.toDictionary(),
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
