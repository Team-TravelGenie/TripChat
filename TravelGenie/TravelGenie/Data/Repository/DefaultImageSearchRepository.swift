//
//  DefaultImageSearchRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/30.
//

import Moya

final class DefaultImageSearchRepository: ImageSearchRepository {
    
    private let networkService = NetworkService()
    
    // TODO: - 넣어줄 Info 타입 정의
    func searchImage(
        _ info: String,
        completion: @escaping (Result<String, Error>) -> Void)
    {
        let requestModel = ImageSearchRequestModel(q: "", exactTerms: "")
        networkService.request(GoogleCustomSearchAPI.imageSearch(requestModel)) { result in
            switch result {
            case .success(let response):
                completion(.success(response.items.link))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
