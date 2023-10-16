//
//  DefaultTranslateRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/01.
//

import Foundation

final class DefaultTranslateRepository: TranslateRepository {
    
    private let provider = MultiMoyaProvider()
    
    func translate(
        with keywords: String,
        completion: @escaping ((Result<String, ResponseError>) -> Void))
    {
        let requestModel = PapagoTranslateRequestModel(text: keywords)
        
        provider.request(.target(PapagoTranslateAPI.translate(requestModel))) {
            let result = $0.mapError { error -> ResponseError in
                return .moyaError(error)
            }.flatMap { response -> Result<String, ResponseError> in
                do {
                    let dto = try response.map(PapagoTranslateAPI.ResultType.self)
                    let translation = dto.message.result.translatedText
                    
                    return translation.isEmpty ? .failure(.emptyResponse) : .success(translation)
                } catch {
                    return .failure(.moyaError(.jsonMapping(response)))
                }
            }
            
            completion(result)
        }
    }
}
