//
//  GoogleVisionRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/29.
//

import Moya

protocol GoogleVisionRepository {
    func requestImageLabelDetection(
        _ content: String,
        completion: @escaping (Result<DetectedImageLabel, Error>) -> Void)
        -> Cancellable
    
    func requestLandmarkDetection(
        _ content: String,
        completion: @escaping (Result<DetectedLandmark, Error>) -> Void)
        -> Cancellable
}
