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
    
    func requestImageLabelDetection(
        _ content: String,
        completion: @escaping (Result<DetectedImageLabel, Error>) -> Void
    ) -> Cancellable {
        // TODO: usecase 생성하도록 수정
        let requestModel = LabelDetectionRequestModel(
            requests: [
                Request(image: Image(content: content),
                        features: [Feature()]
                       )
            ]
        )
        
        return networkService.request(GoogleVisionLabelDetectionAPI.labelDetection(requestModel)) { result in
            switch result {
            case .success(let response):
                let mappedResponse = response.mapToDetectedImageLabel(from: response)
                completion(.success(mappedResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
