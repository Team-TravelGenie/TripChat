//
//  TranslateRepository.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/01.
//

protocol TranslateRepository {
    func translate(
        with keywords: String,
        completion: @escaping ((Result<String, ResponseError>) -> Void))
}
