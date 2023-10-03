//
//  LanguageCode.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/10/03.
//

import Foundation

enum LanguageCode {
    case korean
    case english
    
    var locationSearchCode: String {
        switch self {
        case .korean:
            return "kr"
        case .english:
            return "en"
        }
    }
    
    var photosSearchCode: String {
        switch self {
        case .korean:
            return "ko"
        case .english:
            return "en"
        }
    }
}
