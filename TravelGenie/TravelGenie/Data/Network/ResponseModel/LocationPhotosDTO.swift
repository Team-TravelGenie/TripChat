//
//  LocationPhotosDTO.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/25.
//

import Foundation

struct LocationPhotosDTO: Decodable {
    let data: [Datum]
}

extension LocationPhotosDTO {
    struct Datum: Codable {
        let images: Images
        let source: Source
        let user: User?
        let id: Int
        let isBlessed: Bool
        let album: String
        let caption: String
        let publishedDate: String
        
        enum CodingKeys: String, CodingKey {
            case images, source, user, id
            case isBlessed = "is_blessed"
            case album, caption
            case publishedDate = "published_date"
        }
    }
}

extension LocationPhotosDTO.Datum {
    struct Images: Codable {
        let original: ImageDetail
        let large: ImageDetail
        let medium: ImageDetail
        let small: ImageDetail
        let thumbnail: ImageDetail
    }
    
    struct Source: Codable {
        let name: String
        let localizedName: String

        enum CodingKeys: String, CodingKey {
            case name
            case localizedName = "localized_name"
        }
    }

    struct User: Codable {
        let username: String
    }
}

extension LocationPhotosDTO.Datum.Images {
    struct ImageDetail: Codable {
        let height, width: Int
        let url: String
    }
}
