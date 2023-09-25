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
        spot: String,
        completion: @escaping (Result<Data, Error>) -> Void)
}

final class DefaultImageSearchUseCase: ImageSearchUseCase {
    
    private let repository: ImageSearchRepository
    
    init(repository: ImageSearchRepository) {
        self.repository = repository
    }
    
    func searchImage(
        with tags: [Tag],
        spot: String,
        completion: @escaping (Result<Data, Error>) -> Void)
    {
        let themeTags = tags.filter { $0.category == .theme }
        let keywordTags = tags.filter { $0.category == .keyword }
        let tags = themeTags + keywordTags
        
        repository.searchImage(with: tags, spot: spot) { result in
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
