//
//  DateFormatter+shared.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/21.
//

import Foundation

extension DateFormatter {
    static let formatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter
    }()
}
