//
//  DefaultRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation
import Moya

final class DefaultRepository {
    private let networkService = NetworkService()
    
    func requestDetectedImageLabel(completion: @escaping (Result<DetectedImageLabel, Error>) -> Void) -> Cancellable {
        networkService.request(VisionLabelAPI.labelDetection) { result in
            switch result {
            case .success(let response):
                let mappedResponse = response.mapToAIDectectedImageLabel(from: response)
                completion(.success(mappedResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
