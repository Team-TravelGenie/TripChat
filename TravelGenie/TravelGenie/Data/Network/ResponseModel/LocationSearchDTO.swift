//
//  LocationSearchDTO.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation

struct LocationSearchDTO: Decodable {
    let data: [Datum]
}

extension LocationSearchDTO {
    struct Datum: Codable {
        let locationID: String
        let name: String
        let addressObj: AddressObj

        enum CodingKeys: String, CodingKey {
            case locationID = "location_id"
            case name
            case addressObj = "address_obj"
        }
    }
}

extension LocationSearchDTO.Datum {
    struct AddressObj: Codable {
        let street1: String?
        let street2: String?
        let city: String?
        let state: String?
        let country: String
        let postalcode: String?
        let addressString: String
        
        enum CodingKeys: String, CodingKey {
            case street1, street2, city, state, country, postalcode
            case addressString = "address_string"
        }
    }
}
