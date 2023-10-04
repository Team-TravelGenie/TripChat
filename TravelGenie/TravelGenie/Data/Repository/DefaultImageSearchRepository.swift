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
        completion: @escaping (Result<[String], ResponseError>) -> Void)
    {
        let query = tags.map { $0.value }.joined(separator: " ")
        let requestModel = ImageSearchRequestModel(q: query, exactTerms: spot)
        networkService.request(GoogleCustomSearchAPI.imageSearch(requestModel)) { result in
            switch result {
            case .success(let response):
                guard let link = response.items.first?.link else {
                    completion(.failure(.emptyResponse))
                    return
                }
                let links = response.items.map { $0.link }
                
                completion(.success(links))
            case .failure(let error):
                completion(.failure(.moyaError(error)))
            }
        }
    }
}
