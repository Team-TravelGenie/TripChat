//
//  DefaultLocationSearchRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/26.
//

import Foundation

final class DefaultLocationSearchRepository: LocationSearchRepository {
    
    private let networkService = NetworkService()
    
    func searchPhoto(
        locationID: String,
        languageCode: String,
        completion: @escaping ((Result<String, ResponseError>) -> Void))
    {
        let requestModel = LocationPhotosRequestModel(language: languageCode, locationId: locationID)
        
        networkService.request(TripadvisorLocationPhotosAPI.locationPhotos(requestModel)) { result in
            switch result {
            case .success(let response):
                guard let imageUrl = response.data.first?.images.large.url else {
                    completion(.failure(.emptyResponse))
                    return
                }
                
                completion(.success(imageUrl))
            case .failure(let error):
                completion(.failure(.moyaError(error)))
            }
        }
    }
}
