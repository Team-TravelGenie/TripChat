//
//  UserFeedbackUseCase.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/05.
//

protocol UserFeedbackUseCase {
    func save(
        userFeedback: UserFeedback,
        completion: @escaping ((Error?) -> Void)
    )
}

final class DefaultUserFeedbackUseCase: UserFeedbackUseCase {
    
    private let userFeedbackRepository: UserFeedbackRepository
    
    init(userFeedbackRepository: UserFeedbackRepository) {
        self.userFeedbackRepository = userFeedbackRepository
    }
    
    func save(
        userFeedback: UserFeedback,
        completion: @escaping ((Error?) -> Void)
    ) {
        userFeedbackRepository.save(
            userFeedback: userFeedback,
            completion: completion)
    }
}
