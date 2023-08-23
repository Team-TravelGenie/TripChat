//
//  MessageKind+description.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/22.
//

import Foundation
import MessageKit

extension MessageKind {
    var description: String {
        switch self {
        case .custom(let item):
            if item is TagItem { return "tag" }
            else if item is RecommendationItem { return "recommendation" }
            else { return String(describing: self) }
        default:
            return String(describing: self)
        }
    }
}
