//
//  DefaultImageSearchRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/30.
//

import Moya

final class DefaultImageSearchRepository: ImageSearchRepository {
    
    private let provider = MultiMoyaProvider()
    
    func searchImage(
        with tags: [Tag],
        spot: String,
        completion: @escaping (Result<[String], ResponseError>) -> Void)
    {
        let query = tags.map { $0.value }.joined(separator: " ")
        let requestModel = ImageSearchRequestModel(q: query, exactTerms: spot)
        
        provider.request(.target(GoogleCustomSearchAPI.imageSearch(requestModel))) {
            let result = $0.mapError { error -> ResponseError in
                return .moyaError(error)
            }.flatMap { response -> Result<[String], ResponseError> in
                do {
                    let dto = try response.map(GoogleCustomSearchAPI.ResultType.self)
                    let links = dto.items.map { item in
                        item.link
                    }
                    
                    return links.isEmpty ? .failure(.emptyResponse) : .success(links)
                } catch {
                    return .failure(.moyaError(.jsonMapping(response)))
                }
            }
            
            completion(result)
        }
    }
}
