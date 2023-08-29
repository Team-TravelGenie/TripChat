//
//  DefaultOpenAIRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/07/28.
//

import Foundation
import OpenAISwift

final class DefaultOpenAIRepository: OpenAIRepository {
    
    private let openAI = OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: SecretStorage.OpenAIAPIKey))
    
    func request(
        chatMessages: [ChatMessage],
        completion: @escaping (Result<OpenAI<MessageResult>, OpenAIError>) -> Void)
    {
        openAI.sendChat(with: chatMessages) { result in
            switch result {
            case .success(let messageResult):
                completion(.success(messageResult))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
