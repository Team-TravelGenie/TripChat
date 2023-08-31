//
//  TranslateDTO.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/01.
//

import Foundation

struct TranslateDTO: Decodable {
    let message: TranslationMessage
}

extension TranslateDTO {
    struct TranslationMessage: Decodable {
        let result: Result
        let type: String
        let service: String
        let version: String
        
        enum CodingKeys: String, CodingKey {
            case result
            case type = "@type"
            case service = "@service"
            case version = "@version"
        }
    }
}

extension TranslateDTO.TranslationMessage {
    struct Result: Decodable {
        let srcLangType: String
        let tarLangType: String
        let translatedText: String
        let engineType: String
    }
}
