//
//  OpenAIRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/07/28.
//

import Foundation
import OpenAISwift

final class OpenAIRepository {
    private let openAI = OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: SecretStorage.OpenAIAPIKey))
    
    func request(
        chat: [ChatMessage],
        completion: @escaping (Result<[MessageResult], Error>) -> Void)
    {
        openAI.sendChat(with: chat) { result in
                switch result {
                case .success(let messageResult):
                    completion(.success(messageResult.choices!))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
