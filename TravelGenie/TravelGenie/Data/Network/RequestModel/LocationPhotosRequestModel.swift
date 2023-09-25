//
//  LocationPhotosRequestModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation

struct LocationPhotosRequestModel: Encodable {
    let key: String = SecretStorage.TripadvisorClientKey
    let language: String = "en"
    let locationId: String
    
    init(locationId: String) {
        self.locationId = locationId
    }
}
