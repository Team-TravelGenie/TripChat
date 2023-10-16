//
//  DefaultLocationSearchRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation

final class DefaultLocationSearchRepository: LocationSearchRepository {
    
    private let provider = MultiMoyaProvider()
    
    func searchLocation(
        query: String,
        languageCode: LanguageCode,
        completion: @escaping ((Result<String, ResponseError>) -> Void))
    {
        let requestModel = LocationSearchRequestModel(language: languageCode.locationSearchCode, searchQuery: query)
        
        provider.request(.target(TripadvisorLocationSearchAPI.locationSearch(requestModel))) {
            let result = $0.mapError { error -> ResponseError in
                return .moyaError(error)
            }.flatMap { response -> Result<String, ResponseError> in
                do {
                    let dto = try response.map(TripadvisorLocationSearchAPI.ResultType.self)
                    
                    if let locationID = dto.data.first?.locationID {
                        return .success(locationID)
                    }
                    
                    return .failure(.emptyResponse)
                } catch {
                    return .failure(.moyaError(.jsonMapping(response)))
                }
            }
            
            completion(result)
        }
    }
}
