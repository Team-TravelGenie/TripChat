//
//  PapagoTranslateAPI.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/01.
//

import Foundation
import Moya

enum PapagoTranslateAPI {
    case translate(PapagoTranslateRequestModel)
}

extension PapagoTranslateAPI: DecodableTargetType {
    
    typealias ResultType = TranslateDTO
    
    var baseURL: URL {
        return URL(string: "https://openapi.naver.com")!
    }
    
    var path: String {
        return "/v1/papago/n2mt"
    }
    
    var method: Moya.Method {
        switch self {
        case .translate:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .translate(let requestModel):
            return .requestParameters(
                parameters: requestModel.toDictionary(),
                encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .translate:
            return [
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "X-Naver-Client-Id": "\(SecretStorage.PapagoTranslateClientID)",
                "X-Naver-Client-Secret": "\(SecretStorage.PapagoTranslateClientSecret)"
            ]
        }
    }
}
