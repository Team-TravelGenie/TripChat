//
//  TagStorage.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/24.
//

import Foundation

final class TagStorage {
    private var tagList = [MockTag]()
    
    var count: Int {
        return tagList.count
    }
    
    var locationTagList: [MockTag] {
        return tagList.filter { $0.category == .location }
    }
    
    var themeTagList: [MockTag] {
        return tagList.filter { $0.category == .theme }
    }
    
    init() {
        self.tagList = setDefaultTagList()
    }
    
    func insertTags(tags: [MockTag]) {
        tags.forEach { tagList.append($0) }
    }
    
    private func setDefaultTagList() -> [MockTag] {
        let defaultTag = [
            MockTag(category: .location, text: "국내"),
            MockTag(category: .location, text: "해외")
        ]
        
        return defaultTag
    }
    
}
