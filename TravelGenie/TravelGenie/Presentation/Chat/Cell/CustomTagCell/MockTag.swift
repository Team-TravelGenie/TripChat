//
//  MockTag.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/24.
//

import Foundation

struct MockTag {
    let category: Category
    let text: String
    let isOn: Bool = false
}

struct MockTagItem {
    var tags: [MockTag]
}

enum Category {
    case location
    case theme
}
