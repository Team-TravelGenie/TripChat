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
        selectedTags: [String],
        recommendations: [String],
        completion: @escaping ((Error?) -> Void))
    {
        let requestModel = UserFeedbackRequestModel(
            isPositive: userFeedback.isPositive,
            content: userFeedback.content,
            selectedTags: selectedTags,
            recommendations: recommendations)
        
        userFeedbackStorage.save(requestModel: requestModel, completion: completion)
    }
}
