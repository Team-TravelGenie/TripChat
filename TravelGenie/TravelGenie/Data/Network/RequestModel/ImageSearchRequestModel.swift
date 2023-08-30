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
    let num: Int = 1
    let safe = "active"
    let rights = "(cc_publicdomain%7Ccc_attribute%7Ccc_sharealike).-(cc_noncommercial)"
    let q: String
    let exactTerms: String
    
    // TODO: - exactTerms에는 spot이 들어가고
    // q에는 사용자가 선택한 태그 + country가 들어가면 좋을 듯
    init(q: String, exactTerms: String) {
        self.q = q
        self.exactTerms = exactTerms
    }
}
