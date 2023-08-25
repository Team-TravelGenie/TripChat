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
    
    var locationTags: [MockTag] {
        return tags.filter { $0.category == .location }
    }
    
    var themeTags: [MockTag] {
        return tags.filter { $0.category == .theme }
    }
    
    private var selectedTags: [MockTag] {
        return tags.filter { $0.isOn == true }
    }
    
    init() {
        tags = setDefaultTags()
    }
    
    func getSelectedTags() -> [MockTag]? {
        return selectedTags.isEmpty ? nil : selectedTags
    }
    
    func insertTags(_ tags: [MockTag]) {
        tags.forEach { self.tags.append($0) }
    }
    
    func updateTagSelectionState(value: String, isSelected: Bool) {
        if let index = tags.firstIndex(where: { $0.text == value }) {
            tags[index].isOn = isSelected
        }
    }
    
    private func setDefaultTags() -> [MockTag] {
        let defaultTag = [
            MockTag(category: .location, text: "국내"),
            MockTag(category: .location, text: "해외")
        ]
        
        return defaultTag
    }
}
