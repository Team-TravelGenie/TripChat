//
//  BottomMenuItem.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/17.
//

struct BottomMenuItem {
    
    enum ItemType {
        case termsOfService
        case privacyPolicy
        case inquiries
    }
    
    let type: ItemType
    
    var title: String {
        switch type {
        case .termsOfService:
            return "서비스 이용약관"
        case .privacyPolicy:
            return "개인정보처리방침"
        case .inquiries:
            return "문의"
        }
    }
    
    var url: String {
        switch type {
        case .termsOfService:
            return "https://github.com/Team-TravelGenie/TripChat"
        case .privacyPolicy:
            return "https://github.com/Team-TravelGenie/TripChat"
        case .inquiries:
            return "https://github.com/Team-TravelGenie/TripChat"
        }
    }
}
