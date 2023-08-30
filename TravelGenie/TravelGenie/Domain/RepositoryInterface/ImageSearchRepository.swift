//
//  GoogleCustomSearchRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/30.
//

protocol ImageSearchRepository {
    func searchImage(
        with tags: [Tag],
        spot: String,
        completion: @escaping (Result<String, Error>) -> Void)
}
