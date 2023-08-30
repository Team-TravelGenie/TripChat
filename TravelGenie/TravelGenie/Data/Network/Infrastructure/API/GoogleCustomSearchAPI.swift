//
//  GoogleCustomSearchAPI.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/29.
//

import Foundation
import Moya

enum GoogleCustomSearchAPI {
    case imageSearch(ImageSearchRequestModel)
}

extension GoogleCustomSearchAPI: DecodableTargetType {
    
    typealias ResultType = ImageSearchDTO
    
    var baseURL: URL {
        return URL(string:"https://www.googleapis.com")!
    }
    
    var path: String {
        return "/customsearch/v1"
    }
    
    var method: Moya.Method {
        switch self {
        case .imageSearch:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .imageSearch(let requestModel):
            return .requestParameters(
                parameters: requestModel.toDictionary(),
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
