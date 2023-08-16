//
//  Font.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/17.
//

import UIKit

enum Font {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case bodyBold
    case bodyRegular
    case captionBold
    case captionRegular
    case micro
    
    var weight: UIFont.Weight {
        switch self {
        case .bodyRegular, .captionRegular, .micro:
            return .regular
        default:
            return .bold
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .title1:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .bodyBold, .bodyRegular:
            return 15
        case .captionBold, .captionRegular:
            return 12
        case .micro:
            return 12
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .largeTitle:
            return fontSize * 1.3
        case .micro:
            return fontSize * 1.0
        default:
            return fontSize * 1.5
        }
    }
}
