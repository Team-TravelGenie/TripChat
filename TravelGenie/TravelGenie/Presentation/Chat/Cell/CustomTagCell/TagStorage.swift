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
    
    private var selectedTagList: [MockTag] {
        return tagList.filter { $0.isOn == true }
    }
    
    init() {
        self.tagList = setDefaultTagList()
    }
    
    func getSelectedTags() -> [MockTag]? {
        return selectedTagList.isEmpty ? nil : selectedTagList
    }
    
    func insertTags(tags: [MockTag]) {
        tags.forEach { tagList.append($0) }
    }
    
    func updateTagIsOn(value: String, isSelected: Bool) {
        if let index = tagList.firstIndex(where: { $0.text == value }) {
            tagList[index].isOn = isSelected
        }
    }
    
    private func setDefaultTagList() -> [MockTag] {
        let defaultTag = [
            MockTag(category: .location, text: "국내"),
            MockTag(category: .location, text: "해외")
        ]
        
        return defaultTag
    }
}
