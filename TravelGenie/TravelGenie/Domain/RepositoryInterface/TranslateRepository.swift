//
//  TranslateRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/01.
//

import Foundation

protocol TranslateRepository {
    func translate(
        with kewords: String,
        completion: @escaping ((Result<String, Error>) -> Void))
}
