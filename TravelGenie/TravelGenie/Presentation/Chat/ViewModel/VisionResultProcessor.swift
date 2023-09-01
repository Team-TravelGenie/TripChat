//
//  VisionResultProcessor.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/30.
//

import Foundation

final class VisionResultProcessor {
    
    private struct VisionResults {
        var keywords: [Keyword]
        var landmarks: [Landmark]
    }
    
    private var visionResults = VisionResults(keywords: [], landmarks: [])
    private let translateUseCase: TranslateUseCase
    
    init(
        translateUseCase: TranslateUseCase = DefaultTranslateUseCase(
            translateRepository: DefaultTranslateRepository()))
    {
        self.translateUseCase = translateUseCase
    }
    
    func addKeywords(_ keywords: [Keyword]) {
        visionResults.keywords.append(contentsOf: keywords)
    }
    
    func addLandmarks(_ landmarks: [Landmark]) {
        visionResults.landmarks.append(contentsOf: landmarks)
    }
    
    func getSixMostConfidentTranslatedTags(completion: @escaping ([Tag]) -> Void) {
        let sortedAndJoinedKeywords = keywordsOrderedByConfidence().joined(separator: ",")
        
        translate(keyword: sortedAndJoinedKeywords) { [weak self] result in
            guard let self else { return }
            
            var deDuplicatedResult = self.removeDuplicateValues(text: result)
            
            if deDuplicatedResult.count > 6 {
                deDuplicatedResult = Array(deDuplicatedResult.prefix(6))
            }
            
            let topSixTags = self.convertToTags(texts: deDuplicatedResult)
            
            completion(topSixTags)
        }
    }
    
    private func keywordsOrderedByConfidence() -> [String] {
        let sortedLandmarks = visionResults.landmarks.sorted(by: { $0.confidence > $1.confidence }).map { $0.place }
        let sortedKeywords = visionResults.keywords.sorted(by: { $0.confidence > $1.confidence }).map { $0.name }
        
        return sortedLandmarks + sortedKeywords
    }
    
    private func removeDuplicateValues(text: String) -> [String] {
        let results = text.split(separator: ",")
        let trimmingResults = results.map { String($0).replacingOccurrences(of: " ", with: "") }
        
        return Array(Set(trimmingResults))
    }
    
    private func translate(keyword: String, completion: @escaping (String) -> Void) {
        translateUseCase.translateKeywords(with: keyword) { result in
            switch result {
            case .success(let translatedKeyword):
                completion(translatedKeyword)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func convertToTags(texts: [String]) -> [Tag] {
        return texts.map { Tag(category: .theme, value: $0) }
    }
}
