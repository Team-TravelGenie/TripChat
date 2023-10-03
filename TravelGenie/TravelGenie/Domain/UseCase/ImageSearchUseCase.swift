//
//  ImageSearchUseCase.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/30.
//

import Foundation

protocol ImageSearchUseCase {
    func searchImage(
        with tags: [Tag],
        item: OpenAIRecommendation.RecommendationItem,
        completion: @escaping (Result<Data, Error>) -> Void)
}

final class DefaultImageSearchUseCase: ImageSearchUseCase {
    
    private let imageSearchRepository: ImageSearchRepository
    private let locationSearchRepository: LocationSearchRepository
    private let locationPhotosRepository: LocationPhotoRepository
    
    init(
        imageSearchRepository: ImageSearchRepository,
        locationPhotoRepository: LocationPhotoRepository,
        locationSearchRepository: LocationSearchRepository)
    {
        self.imageSearchRepository = imageSearchRepository
        self.locationSearchRepository = locationSearchRepository
        self.locationPhotosRepository = locationPhotoRepository
    }
    
    func searchImage(
        with tags: [Tag],
        item: OpenAIRecommendation.RecommendationItem,
        completion: @escaping (Result<Data, Error>) -> Void)
    {
        let tags = tags.filter { $0.category == .theme || $0.category == .keyword }
        
        if item.country == "한국" {
            handleLocationSearch(query: item.spotKorean, languageCode: .korean, tags: tags, spot: item.spotKorean, completion: completion)
        } else {
            handleLocationSearch(query: item.spotEnglish, languageCode: .english, tags: tags, spot: item.spotEnglish, completion: completion)
        }
    }
    
    private func handleLocationSearch(
        query: String,
        languageCode: LanguageCode,
        tags: [Tag],
        spot: String,
        completion: @escaping (Result<Data, Error>) -> Void)
    {
        locationSearchRepository.searchLocation(query: query, languageCode: languageCode) { [weak self] result in
            switch result {
            case .success(let locationID):
                self?.handleLocationPhotoSearch(locationID: locationID, languageCode: languageCode, tags: tags, spot: spot, completion: completion)
            case .failure:
                self?.handleImageSearch(tags: tags, spot: spot, completion: completion)
            }
        }
    }
    
    private func handleLocationPhotoSearch(
        locationID: String,
        languageCode: LanguageCode,
        tags: [Tag],
        spot: String,
        completion: @escaping (Result<Data, Error>) -> Void)
    {
        locationPhotosRepository.searchPhoto(locationID: locationID, languageCode: languageCode) { [weak self] result in
            switch result {
            case .success(let imageURL):
                ImageManager.retrieveImage(with: imageURL) { data in
                    completion(.success(data))
                }
            case .failure:
                self?.handleImageSearch(tags: tags, spot: spot, completion: completion)
            }
        }
    }
    
    private func handleImageSearch(
        tags: [Tag],
        spot: String,
        completion: @escaping (Result<Data, Error>) -> Void)
    {
        imageSearchRepository.searchImage(with: tags, spot: spot, completion: { result in
            switch result {
            case .success(let imageURL):
                ImageManager.retrieveImage(with: imageURL) { data in
                    completion(.success(data))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
