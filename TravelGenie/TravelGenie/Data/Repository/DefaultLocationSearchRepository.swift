//
//  DefaultLocationSearchRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation

final class DefaultLocationSearchRepository: LocationSearchRepository {
    
    private let networkService = NetworkService()
    
    func searchLocation(
        query: String,
        languageCode: LanguageCode,
        completion: @escaping ((Result<String, ResponseError>) -> Void))
    {
        let requestModel = LocationSearchRequestModel(language: languageCode.locationSearchCode, searchQuery: query)
        
        networkService.request(TripadvisorLocationSearchAPI.locationSearch(requestModel)) { result in
            switch result {
            case .success(let response):
                guard let locationID = response.data.first?.locationID else {
                    completion(.failure(.emptyResponse))
                    return
                }
                
                completion(.success(locationID))
            case .failure(let error):
                completion(.failure(.moyaError(error)))
            }
        }
    }
}
