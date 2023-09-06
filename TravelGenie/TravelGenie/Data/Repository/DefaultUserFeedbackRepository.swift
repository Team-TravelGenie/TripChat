//
//  DefaultUserFeedbackRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/05.
//

final class DefaultUserFeedbackRepository: UserFeedbackRepository {
    
    private let userFeedbackStorage: UserFeedbackStroage
    
    init(userFeedbackStorage: UserFeedbackStroage) {
        self.userFeedbackStorage = userFeedbackStorage
    }
    
    func save(
        userFeedback: UserFeedback,
        completion: @escaping ((Error?) -> Void))
    {
        let requestModel = UserFeedbackRequestModel(userFeedback: userFeedback)
        userFeedbackStorage.save(requestModel: requestModel, completion: completion)
    }
}
