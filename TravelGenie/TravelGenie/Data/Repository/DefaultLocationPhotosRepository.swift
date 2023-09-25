//
//  DefaultLocationPhotosRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation

final class DefaultLocationPhotosRepository: LocationPhotosRepository {
    
    private let networkService = NetworkService()
    
    func searchLocation(
        query: String,
        languageCode: String,
        completion: @escaping ((Result<String, Error>) -> Void))
    {
        let requestModel = LocationSearchRequestModel(language: languageCode, searchQuery: query)
        
        networkService.request(TripadvisorLocationSearchAPI.locationSearch(requestModel)) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchPhotos(
        locationID: String,
        languageCode: String,
        completion: @escaping ((Result<String, Error>) -> Void))
    {
        let requestModel = LocationPhotosRequestModel(language: languageCode, locationId: locationID)
        
        networkService.request(TripadvisorLocationPhotosAPI.locationPhotos(requestModel)) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
