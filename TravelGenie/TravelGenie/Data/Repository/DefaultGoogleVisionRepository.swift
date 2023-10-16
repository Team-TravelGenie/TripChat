//
//  DefaultGoogleVisionRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation
import Moya

final class DefaultGoogleVisionRepository: GoogleVisionRepository {
    private let networkService = NetworkService()
    
    func requestImageLabelDetection(
        _ content: String,
        completion: @escaping (Result<DetectedImageLabel, ResponseError>) -> Void)
        -> Cancellable
    {
        let requestModel = GoogleVisionRequestModel(
            base64EncodedImageData: content,
            requestType: .labelDetection)
        
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
        completion: @escaping (Result<DetectedLandmark, ResponseError>) -> Void)
        -> Cancellable
    {
        let requestModel = GoogleVisionRequestModel(
            base64EncodedImageData: content,
            requestType: .landmarkDetection)
        
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
