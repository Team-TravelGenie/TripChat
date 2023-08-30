//
//  ImageSearchDTO.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/29.
//

import Foundation

struct ImageSearchDTO: Decodable {
    let items: Item
}

extension ImageSearchDTO {
    struct Item: Decodable {
        let link: String
    }
}
