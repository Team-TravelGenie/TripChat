//
//  TagStorage.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/24.
//

import Foundation

final class TagStorage {
    
    var count: Int {
        return tags.count
    }
    
    var locationTags: [Tag] {
        return tags.filter { $0.category == .location }
    }
    
    var themeTags: [Tag] {
        return tags.filter { $0.category == .theme }
    }
    
    private var tags = [Tag]()
    private var selectedTags: [Tag] {
        return tags.filter { $0.isSelected == true }
    }
    
    // MARK: Lifecycle
    
    init() {
        tags = setDefaultTags()
    }
    
    // MARK: Internal
    
    func getSelectedTags() -> [Tag]? {
        return selectedTags.isEmpty ? nil : selectedTags
    }
    
    func insertTags(_ tags: [Tag]) {
        tags.forEach { self.tags.append($0) }
    }
    
    func updateTagSelectionState(value: String, isSelected: Bool) {
        if let index = tags.firstIndex(where: { $0.value == value }) {
            tags[index].isSelected = isSelected
        }
    }
    
    // MARK: Private
    
    private func setDefaultTags() -> [Tag] {
        let defaultTag = [
            Tag(category: .location, value: "국내"),
            Tag(category: .location, value: "해외")]
        
        return defaultTag
    }
}
