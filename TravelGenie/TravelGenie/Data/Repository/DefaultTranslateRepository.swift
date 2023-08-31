//
//  DefaultTranslateRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/01.
//

import Foundation

final class DefaultTranslateRepository: TranslateRepository {
    
    private let networkService = NetworkService()
    
    func translate(
        with kewords: String,
        completion: @escaping ((Result<String, Error>) -> Void))
    {
        let requestModel = PapagoTranslateRequestModel(text: kewords)
        
        networkService.request(PapagoTranslateAPI.translate(requestModel)) { result in
            switch result {
            case .success(let response):
                completion(.success(response.message.result.translatedText))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
