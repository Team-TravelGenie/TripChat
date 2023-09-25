//
//  LocationPhotosUseCase.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation

enum LanguageCode: String {
    case english = "en"
    case korean = "kr"
}

protocol LocationPhotosUseCase {
    func searchLocation(
        query: String,
        languageCode: LanguageCode,
        completion: @escaping ((Result<String, Error>) -> Void))
    
    func searchPhoto(
        locationID: String,
        languageCode: LanguageCode,
        completion: @escaping ((Result<String, Error>) -> Void))
}

final class DefaultLocationPhotosUseCase: LocationPhotosUseCase {
    
    private let locationPhotosRepository: LocationPhotosRepository
    
    init(locationPhotosRepository: LocationPhotosRepository) {
        self.locationPhotosRepository = locationPhotosRepository
    }
    
    func searchLocation(
        query: String,
        languageCode: LanguageCode,
        completion: @escaping ((Result<String, Error>) -> Void))
    {
        locationPhotosRepository.searchLocation(query: query, languageCode: languageCode.rawValue) { result in
            switch result {
            case .success(let locationID):
                completion(.success(locationID))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchPhoto(
        locationID: String,
        languageCode: LanguageCode,
        completion: @escaping ((Result<String, Error>) -> Void))
    {
        locationPhotosRepository.searchPhoto(locationID: locationID, languageCode: languageCode.rawValue) { result in
            switch result {
            case .success(let imageUrl):
                completion(.success(imageUrl))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
