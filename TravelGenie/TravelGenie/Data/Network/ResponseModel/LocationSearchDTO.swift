//
//  LocationSearchDTO.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation

struct LocationSearchDTO: Codable {
    let data: [Datum]
}

extension LocationSearchDTO {
    struct Datum: Codable {
        let locationID, name: String
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
        let city, country: String
        let postalcode: String?
        let addressString: String
        let street2, state: String?
        
        enum CodingKeys: String, CodingKey {
            case street1, city, country, postalcode
            case addressString = "address_string"
            case street2, state
        }
    }
}
