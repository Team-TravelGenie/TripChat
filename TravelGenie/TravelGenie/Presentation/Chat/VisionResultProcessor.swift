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
    
    private let translateUseCase: TranslateUseCase
    private let keywordsToFilter: [String] = [
        "Water",
        "Water resources",
        "Fluvial landforms of streams",
        "Body of water",
        "Natural environment",
        "Watercourse",
        "Landscape",
        "Atmosphere",
        "World",
        "Groundcover",
    ]
    
    private var visionResults = VisionResults(keywords: [], landmarks: [])
    
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
    
    func getFourMostConfidentTranslatedTags(completion: @escaping ([Tag]) -> Void) {
        let filteredKeywords = filteredKeywords()
        let jointKeywords = filteredKeywords.joined(separator: ", ")
        
        translate(keyword: jointKeywords) { [weak self] result in
            guard let self else { return }
            
            var uniqueValues = self.removeDuplicateValues(text: result)
            
            if uniqueValues.count > 4 {
                uniqueValues = Array(uniqueValues.prefix(4))
            }
            
            let topSixTags = self.convertToTags(texts: uniqueValues)
            
            completion(topSixTags)
        }
    }
    
    private func filteredKeywords() -> [String] {
        let filteredKeywords = keywordsOrderedByConfidence().difference(from: keywordsToFilter)
        var result: [String] = []
        
        for change in filteredKeywords {
            switch change {
            case .insert(_, let keyword, _):
                result.append(keyword)
            case .remove:
                continue
            }
        }
        
        return result
    }
    
    private func keywordsOrderedByConfidence() -> [String] {
        let sortedLandmarks = visionResults.landmarks
            .sorted(by: { $0.confidence > $1.confidence })
            .map { $0.place }
        let sortedKeywords = visionResults.keywords
            .sorted(by: { $0.confidence > $1.confidence })
            .map { $0.name }
        
        var twoMostConfidentLandmarks: [String] = []
        var index: Int = 0
        while twoMostConfidentLandmarks.count < 2 {
            if index >= sortedLandmarks.count { break }
            twoMostConfidentLandmarks.append(sortedLandmarks[index])
            index += 1
        }
        
        return twoMostConfidentLandmarks + sortedKeywords
    }
    
    private func removeDuplicateValues(text: String) -> [String] {
        let results = text.split(separator: ",")
        let trimmingResults = results.map { String($0).replacingOccurrences(of: " ", with: "") }
        
        let orderedSetResults = NSOrderedSet(array: trimmingResults)
        
        return orderedSetResults.array.compactMap { $0 as? String }
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
        return texts.map { Tag(category: .keyword, value: $0) }
    }
}
