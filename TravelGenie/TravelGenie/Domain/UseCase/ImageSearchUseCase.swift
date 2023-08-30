//
//  ImageSearchUseCase.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/30.
//

protocol ImageSearchUseCase {
    func searchImage(
        _ info: String,
        completion: @escaping (Result<String, Error>) -> Void)
}

final class DefaultImageSearchUseCase: ImageSearchUseCase {
    
    private let repository: ImageSearchRepository
    
    init(repository: ImageSearchRepository) {
        self.repository = repository
    }
    
    func searchImage(
        _ info: String,
        completion: @escaping (Result<String, Error>) -> Void)
    {
        repository.searchImage(info) { result in
            switch result {
            case .success(let imageURL):
                completion(.success(imageURL))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
