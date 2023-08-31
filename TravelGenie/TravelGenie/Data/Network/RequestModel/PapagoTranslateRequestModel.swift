//
//  PapagoTranslateRequestModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/01.
//

import Foundation

struct PapagoTranslateRequestModel: Encodable {
    let source: String
    let target: String
    let text: String
}
