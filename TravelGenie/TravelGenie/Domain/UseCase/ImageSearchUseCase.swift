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
        
        if item.country == "한국" {
            locationSearchRepository.searchLocation(query: item.spotKorean, languageCode: .korean) { [weak self] result in
                switch result {
                case .success(let locationID):
                    self?.locationPhotosRepository.searchPhoto(locationID: locationID, languageCode: .korean) { result in
                        switch result {
                        case .success(let imageURL):
                            ImageManager.retrieveImage(with: imageURL) { data in
                                completion(.success(data))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let locationSearchError):
                    self?.imageSearchRepository.searchImage(with: tags, spot: item.spotKorean, completion: { result in
                        switch result {
                        case .success(let imageURL):
                            ImageManager.retrieveImage(with: imageURL) { data in
                                completion(.success(data))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    })
                    
                    completion(.failure(locationSearchError))
                }
            }
        } else {
            locationSearchRepository.searchLocation(query: item.spotEnglish, languageCode: .english) { [weak self] result in
                switch result {
                case .success(let locationID):
                    self?.locationPhotosRepository.searchPhoto(locationID: locationID, languageCode: .english) { result in
                        switch result {
                        case .success(let imageURL):
                            ImageManager.retrieveImage(with: imageURL) { data in
                                completion(.success(data))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let locationSearchError):
                    self?.imageSearchRepository.searchImage(with: tags, spot: item.spotEnglish, completion: { result in
                        switch result {
                        case .success(let imageURL):
                            ImageManager.retrieveImage(with: imageURL) { data in
                                completion(.success(data))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    })
                    
                    completion(.failure(locationSearchError))
                }
            }
        }
    }
}
/*
 
 1. 만약, item.country == "한국"이면, item.spotkorean 으로 tripadvisor에 요청을보낸다.
 2. 결과값이 empty이면, googleSearch에 태그 + spotkorean을 검색어로 보낸다.
 3. else(해외 일 경우),
 4. tripadvisor에 spotEnglish로 locationSearch를 보낸다.
 5. 결과값이 empty이면, googleSearch에 태그 + spotEnglish를 검색어로 보낸다.
 
 */

/*
 locationSearchRepository.searchLocation(query: item.spotKorean, languageCode: "kr") { result in
 switch result {
 case .success(let imageURL):
 ImageManager.retrieveImage(with: imageURL) { data in
 completion(.success(data))
 }
 case .failure(let error):
 if case ResponseError.emptyResponse = error {
 self.imageSearchRepository.searchImage(with: tags, spot: item.spotKorean) { result in
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
 }
 } else {
 locationSearchRepository.sear
 }
 */
