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
                let locationID = response.data[0].locationID
                completion(.success(locationID))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchPhoto(
        locationID: String,
        languageCode: String,
        completion: @escaping ((Result<String, Error>) -> Void))
    {
        let requestModel = LocationPhotosRequestModel(language: languageCode, locationId: locationID)
        
        networkService.request(TripadvisorLocationPhotosAPI.locationPhotos(requestModel)) { result in
            switch result {
            case .success(let response):
                let imageUrl = response.data[0].images.large.url
                completion(.success(imageUrl))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
