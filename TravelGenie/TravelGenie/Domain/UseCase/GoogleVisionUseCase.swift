//
//  GoogleVisionUseCase.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/29.
//

import Moya

protocol GoogleVisionUseCase {
    func extractKeywords(
        _ content: String,
        completion: @escaping (Result<DetectedImageLabel, Error>) -> Void)
        -> Cancellable
    
    func extractLandmarks(
        _ content: String,
        completion: @escaping (Result<DetectedLandmark, Error>) -> Void)
        -> Cancellable
}

final class DefaultGoogleVisionUseCase: GoogleVisionUseCase {
    
    private let googleVisionRepository: GoogleVisionRepository
    
    init(googleVisionRepository: GoogleVisionRepository) {
        self.googleVisionRepository = googleVisionRepository
    }
    
    func extractKeywords(
        _ content: String,
        completion: @escaping (Result<DetectedImageLabel, Error>) -> Void)
        -> Cancellable
    {
        
    }
    
    func extractLandmarks(
        _ content: String,
        completion: @escaping (Result<DetectedLandmark, Error>) -> Void)
        -> Cancellable
    {
        
    }
    
    
}
