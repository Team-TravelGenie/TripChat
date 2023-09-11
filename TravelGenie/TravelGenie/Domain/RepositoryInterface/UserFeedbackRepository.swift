//
//  UserFeedbackRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/05.
//

protocol UserFeedbackRepository {
    func save(
        userFeedback: UserFeedback,
        completion: @escaping ((Error?) -> Void)
    )
}
