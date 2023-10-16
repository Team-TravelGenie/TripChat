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
        with keywords: String,
        completion: @escaping ((Result<String, ResponseError>) -> Void))
    {
        let requestModel = PapagoTranslateRequestModel(text: keywords)
        
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
