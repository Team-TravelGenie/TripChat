//
//  LocationPhotosRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

protocol LocationPhotosRepository {
    func searchLocation(
        query: String,
        languageCode: String,
        completion: @escaping ((Result<String, Error>) -> Void))
}
