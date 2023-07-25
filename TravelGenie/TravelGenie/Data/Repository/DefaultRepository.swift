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
        let requestModel = GoogleVisionDetectionRequestModel(
            requests: [
                Request(content: Content(base64EncodedImageData: content),
                        features: [Feature(type: "LABEL_DETECTION")]
                       )
            ]
        )
        
        return networkService.request(GoogleVisionLabelDetectionAPI.labelDetection(requestModel)) { result in
            switch result {
            case .success(let response):
                let mappedResponse = response.mapToDetectedImageLabel()
                completion(.success(mappedResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestLandmarkDetection(
        _ content: String,
        completion: @escaping (Result<DetectedLandmark, Error>) -> Void
    ) -> Cancellable {
        let requestModel = GoogleVisionDetectionRequestModel(
            requests: [
                Request(
                    content: Content(base64EncodedImageData: content),
                    features: [
                        Feature(type: "LANDMARK_DETECTION")
                    ])
            ])
        
        return networkService.request(GoogleVisionLandmarkDetectionAPI.landmarkDetection(requestModel)) { result in
            switch result {
            case .success(let response):
                let mappedResponse = response.mapToDetectedLandmark()
                completion(.success(mappedResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
