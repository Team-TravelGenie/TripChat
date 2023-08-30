//
//  OpenAIUseCase.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/29.
//

import Foundation
import OpenAISwift

enum OpenAIUseCaseError: Error {
    case openAIError(OpenAIError)
    case noMessageDelievered
}

protocol OpenAIUseCase {
    func send(
        chatMessages: [ChatMessage],
        completion: @escaping (Result<[ChatMessage], OpenAIUseCaseError>) -> Void)
}

final class DefaultOpenAIUseCase: OpenAIUseCase {
    
    private let openAIRepository: OpenAIRepository
    
    init(openAIRepository: OpenAIRepository) {
        self.openAIRepository = openAIRepository
    }
    
    func send(
        chatMessages: [ChatMessage],
        completion: @escaping (Result<[ChatMessage], OpenAIUseCaseError>) -> Void)
    {
        openAIRepository.request(chatMessages: chatMessages) { result in
            switch result {
            case .success(let messageResult):
                guard let messageResult = messageResult.choices else {
                    completion(.failure(.noMessageDelievered))
                    return
                }
                
                let chatMessages = messageResult.map { $0.message }
                completion(.success(chatMessages))
            case .failure(let error):
                completion(.failure(.openAIError(error)))
            }
        }
    }
}
