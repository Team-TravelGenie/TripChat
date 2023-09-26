//
//  LocationPhotosRequestModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation

struct LocationPhotosRequestModel: Encodable {
    let key: String = SecretStorage.TripadvisorClientKey
    let language: String
    let locationId: String
    
    init(language: String, locationId: String) {
        self.language = language
        self.locationId = locationId
    }
}
