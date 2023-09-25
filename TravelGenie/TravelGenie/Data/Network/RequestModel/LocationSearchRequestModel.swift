//
//  LocationSearchRequestModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation

struct LocationSearchRequestModel: Encodable {
    let key: String = SecretStorage.TripadvisorClientKey
    let language: String = "en"
    let searchQuery: String
    
    init(searchQuery: String) {
        self.searchQuery = searchQuery
    }
}
