//
//  Chat.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/21.
//

import Foundation

struct Chat {
    let id: UUID
    let createdAt: Date
    let tags: TagItem
    let recommendations: [RecommendationItem]
    let messages: [Message]
}
