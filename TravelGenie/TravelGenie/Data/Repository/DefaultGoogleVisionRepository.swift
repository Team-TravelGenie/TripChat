//
//  DefaultGoogleVisionRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/07/22.
//

import Foundation
import Moya

final class DefaultGoogleVisionRepository: GoogleVisionRepository {
    
    private let provider = MultiMoyaProvider()
    
    func requestImageLabelDetection(
        _ content: String,
        completion: @escaping (Result<DetectedImageLabel, ResponseError>) -> Void)
        -> Cancellable
    {
        let requestModel = GoogleVisionRequestModel(
            base64EncodedImageData: content,
            requestType: .labelDetection)
        
        return provider.request(.target(GoogleVisionLabelDetectionAPI.labelDetection(requestModel))) {
            let result = $0.mapError { error -> ResponseError in
                return .moyaError(error)
            }.flatMap { response -> Result<DetectedImageLabel, ResponseError> in
                do {
                    let dto = try response.map(GoogleVisionLabelDetectionAPI.ResultType.self)
                    let detectedImageLabel = dto.mapToDetectedImageLabel()
                    
                    return .success(detectedImageLabel)
                } catch {
                    return .failure(.moyaError(.jsonMapping(response)))
                }
            }
            
            completion(result)
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
        
        return provider.request(.target(GoogleVisionLandmarkDetectionAPI.landmarkDetection(requestModel))) {
            let result = $0.mapError { error -> ResponseError in
                return .moyaError(error)
            }.flatMap { response -> Result<DetectedLandmark, ResponseError> in
                do {
                    let dto = try response.map(GoogleVisionLandmarkDetectionAPI.ResultType.self)
                    let detectedLandmark = dto.mapToDetectedLandmark()
                    
                    return .success(detectedLandmark)
                } catch {
                    return .failure(.moyaError(.jsonMapping(response)))
                }
            }
            
            completion(result)
        }
    }
}
