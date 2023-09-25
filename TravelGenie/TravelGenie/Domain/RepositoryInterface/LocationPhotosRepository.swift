//
//  LocationPhotosRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation

protocol LocationPhotosRepository {
    func searchLocation(
        query: String,
        languageCode: String,
        completion: @escaping ((Result<String, Error>) -> Void))
    
    func searchPhotos(
        locationID: String,
        languageCode: String,
        completion: @escaping ((Result<String, Error>) -> Void))
}
