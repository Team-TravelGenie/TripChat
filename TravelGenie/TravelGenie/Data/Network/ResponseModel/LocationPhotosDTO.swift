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
        let id: Int
        let isBlessed: Bool
        let caption, publishedDate: String
        let images: Images
        let album: String
        let source: Source
        let user: User
        
        enum CodingKeys: String, CodingKey {
            case id
            case isBlessed = "is_blessed"
            case caption
            case publishedDate = "published_date"
            case images, album, source, user
        }
    }
}

extension LocationPhotosDTO.Datum {
    struct Images: Codable {
        let thumbnail, medium, small, large: Large
        let original: Large
    }
    
    struct Source: Codable {
        let name, localizedName: String

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
    struct Large: Codable {
        let height, width: Int
        let url: String
    }
}
