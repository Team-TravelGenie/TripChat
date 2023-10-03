//
//  LocationPhotosRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

protocol LocationSearchRepository {
    func searchLocation(
        query: String,
        languageCode: LanguageCode,
        completion: @escaping ((Result<String, ResponseError>) -> Void))
}
