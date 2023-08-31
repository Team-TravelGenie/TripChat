//
//  PapagoTranslateRequestModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/01.
//

import Foundation

struct PapagoTranslateRequestModel: Encodable {
    let source: String = "en"
    let target: String = "ko"
    let text: String
    
    init(text: String) {
        self.text = text
    }
}
