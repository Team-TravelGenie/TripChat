//
//  TagStorage.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/24.
//

import Foundation

final class TagStorage {
    
    var didChangeTags: (() -> Void)?
    
    var count: Int {
        return tags.count
    }
    
    var locationTags: [Tag] {
        return tags.filter { $0.category == .location }
    }
    
    var themeTags: [Tag] {
        return tags.filter { $0.category == .theme }
    }
    
    var keywordTags: [Tag] {
        return tags.filter { $0.category == .keyword }
    }
    
    private var tags = [Tag]() {
        didSet {
            didChangeTags?()
        }
    }
    
    private var selectedTags: [Tag] {
        return tags.filter { $0.isSelected == true }
    }
    
    // MARK: Internal
    
    func getSelectedTags() -> [Tag]? {
        return selectedTags.isEmpty ? nil : selectedTags
    }
    
    func insertTags(_ tags: [Tag]) {
        tags.forEach { self.tags.append($0) }
    }
    
    func updateTagSelectionState(value: String, isSelected: Bool) {
        if let index = tags.firstIndex(where: { "#\($0.value)" == value }) {
            tags[index].isSelected = isSelected
        }
    }
}
