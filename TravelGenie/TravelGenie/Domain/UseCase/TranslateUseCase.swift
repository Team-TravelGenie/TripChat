//
//  TranslateUseCase.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/01.
//

import Foundation

protocol TranslateUseCase {
    func translateKewords(
        _ contents: String,
        completion: @escaping (Result<String, Error>) -> Void)
}

final class DefaultTranslateUseCase: TranslateUseCase {
    
    private let translateRepository: TranslateRepository
    
    init(translateRepository: TranslateRepository) {
        self.translateRepository = translateRepository
    }
    
    func translateKewords(
        _ contents: String,
        completion: @escaping (Result<String, Error>) -> Void)
    {
        translateRepository.translate(with: contents) { result in
            switch result {
            case .success(let translatedKeywords):
                completion(.success(translatedKeywords))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
