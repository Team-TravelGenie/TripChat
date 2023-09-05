//
//  UserFeedbackRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/05.
//

protocol UserFeedbackRepository {
    func save(
        userFeedback: UserFeedback,
        selectedTags: [String],
        recommendations: [String],
        completion: @escaping ((Error?) -> Void)
    )
}
