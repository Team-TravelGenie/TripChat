//
//  LocationSearchRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/26.
//

protocol LocationPhotoRepository {
    func searchPhoto(
        locationID: String,
        languageCode: LanguageCode,
        completion: @escaping ((Result<String, ResponseError>) -> Void))
}
