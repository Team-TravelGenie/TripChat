//
//  NetworkService.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation
import Moya

final class NetworkService {
    private let provider = MultiMoyaProvider()
    
    func request<T: DecodableTargetType>(
        _ target: T,
        completion: @escaping (Result<T.ResultType, MoyaError>) -> Void)
        -> Cancellable
    {
        provider.requestDecoded(target) { result in
            switch result {
            case .success(let responseModel):
                completion(.success(responseModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
