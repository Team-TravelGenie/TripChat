//
//  UserFeedbackStorage.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/05.
//

protocol UserFeedbackStroage {
    func save(
        requestModel: UserFeedbackRequestModel,
        completion: @escaping ((Error?) -> Void)
    )
}
