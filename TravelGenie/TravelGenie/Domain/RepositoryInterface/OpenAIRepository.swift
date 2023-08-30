//
//  OpenAIRepository.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/29.
//

import OpenAISwift

protocol OpenAIRepository {
    func request(
        chatMessages: [ChatMessage],
        completion: @escaping (Result<OpenAI<MessageResult>, OpenAIError>) -> Void)
}
