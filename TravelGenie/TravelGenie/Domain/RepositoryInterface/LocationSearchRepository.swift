//
//  LocationSearchRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/26.
//

protocol LocationSearchRepository {
    func searchPhoto(
        locationID: String,
        languageCode: String,
        completion: @escaping ((Result<String, Error>) -> Void))
}
