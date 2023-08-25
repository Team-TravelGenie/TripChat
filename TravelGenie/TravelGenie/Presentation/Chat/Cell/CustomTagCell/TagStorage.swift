//
//  TagStorage.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/24.
//

import Foundation

final class TagStorage {
    private var tags = [MockTag]()
    
    var count: Int {
        return tags.count
    }
    
    var locationTagList: [MockTag] {
        return tags.filter { $0.category == .location }
    }
    
    var themeTagList: [MockTag] {
        return tags.filter { $0.category == .theme }
    }
    
    private var selectedTagList: [MockTag] {
        return tags.filter { $0.isOn == true }
    }
    
    init() {
        self.tags = setDefaultTagList()
    }
    
    func getSelectedTags() -> [MockTag]? {
        return selectedTagList.isEmpty ? nil : selectedTagList
    }
    
    func insertTags(_ tags: [MockTag]) {
        tags.forEach { self.tags.append($0) }
    }
    
    func updateTagIsSelected(value: String, isSelected: Bool) {
        if let index = tags.firstIndex(where: { $0.text == value }) {
            tags[index].isOn = isSelected
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
