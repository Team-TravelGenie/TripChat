//
//  ImageSearchRequestModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/29.
//

import Foundation

struct ImageSearchRequestModel: Encodable {
    let key: String = SecretStorage.GoogleCustomSearchAPIKey
    let cx: String = SecretStorage.GoogleCustomSearchProjectID
    let searchType = "image"
    let imgType = "photo"
    let imgColorType = "color"
    let num: Int = 5
    let safe = "active"
    let rights = "(cc_publicdomain%7Ccc_attribute%7Ccc_sharealike).-(cc_noncommercial)"
    let q: String
    let exactTerms: String
    
    init(q: String, exactTerms: String) {
        self.q = q
        self.exactTerms = exactTerms
    }
}
