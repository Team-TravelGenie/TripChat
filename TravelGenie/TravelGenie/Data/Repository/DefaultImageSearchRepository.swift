//
//  DefaultImageSearchRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/30.
//

import Moya

final class DefaultImageSearchRepository: ImageSearchRepository {
    
    private let networkService = NetworkService()
    
    func searchImage(
        with tags: [Tag],
        spot: String,
        completion: @escaping (Result<String, Error>) -> Void)
    {
        let query = tags.map { $0.value }.joined(separator: " ")
        let requestModel = ImageSearchRequestModel(q: query, exactTerms: spot)
        networkService.request(GoogleCustomSearchAPI.imageSearch(requestModel)) { result in
            switch result {
            case .success(let response):
                completion(.success(response.items[0].link))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
