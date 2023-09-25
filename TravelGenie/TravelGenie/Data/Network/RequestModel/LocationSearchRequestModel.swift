//
//  LocationSearchRequestModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation

struct LocationSearchRequestModel: Encodable {
    let key: String = SecretStorage.TripadvisorClientKey
    let language: String
    let searchQuery: String
    
    init(language: String, searchQuery: String) {
        self.language = language
        self.searchQuery = searchQuery
    }
}
