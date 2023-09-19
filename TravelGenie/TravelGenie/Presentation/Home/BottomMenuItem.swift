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
            return "https://tripchat.notion.site/TripChat-103ba24fe2254fc2980b5468f921f705?pvs=4"
        case .privacyPolicy:
            return "https://tripchat.notion.site/TripChat-9126da1746e84f518b9b9ecfb5373149?pvs=4"
        case .inquiries:
            return "tripchatting@gmail.com"
        }
    }
}
