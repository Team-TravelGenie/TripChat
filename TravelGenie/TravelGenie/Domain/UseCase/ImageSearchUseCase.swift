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
        let themeTags = tags.filter { $0.category == .theme }
        let keywordTags = tags.filter { $0.category == .keyword }
        let tags = themeTags + keywordTags
        
        imageSearchRepository.searchImage(with: tags, spot: item.spotEnglish) { result in
            switch result {
            case .success(let imageURL):
                ImageManager.retrieveImage(with: imageURL) { data in
                    completion(.success(data))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
