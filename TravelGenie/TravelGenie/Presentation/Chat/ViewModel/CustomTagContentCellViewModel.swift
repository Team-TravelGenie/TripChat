//
//  CustomTagContentCellViewModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/25.
//

import Foundation
import UIKit

final class CustomTagContentCellViewModel {
    
    var locationTags: [Tag] {
        return tagStorage.locationTags
    }
    
    var themeTags: [Tag] {
        return tagStorage.themeTags
    }
    
    var keywordTags: [Tag] {
        return tagStorage.keywordTags
    }
    
    var sectionsHeaderTexts: [String] {
        return ["✈️지역", "⛵️테마", "🔑️키워드"]
    }
    
    var didTapSubmitButton: ((Bool) -> Void)?

    private let tagStorage: TagStorage = TagStorage()

    private var submitButtonState: Bool = false {
        didSet {
            didTapSubmitButton?(submitButtonState)
        }
    }
    
    // MARK: Lifecycle
    
    init() {
        bind()
    }
    
    // MARK: Internal
    
    func insertTags(tags: [Tag]) {
        tagStorage.insertTags(tags)
    }
    
    func getSelectedTags() -> [Tag]? {
        guard let isSelectedTags = tagStorage.getSelectedTags() else {
            return nil
        }
        
        return isSelectedTags
    }
    
    func updateTagIsSelected(value: String, isSelected: Bool) {
        tagStorage.updateTagSelectionState(value: value, isSelected: isSelected)
    }
    
    func updateSubmitButtonState(_ state: Bool) {
        submitButtonState = state
    }
    
    func submitSelectedTags(_ selectedTags: [Tag]) {
        NotificationCenter.default.post(
            name: .tagSubmitButtonTapped,
            object: self,
            userInfo: [NotificationKey.selectedTags: selectedTags])
    }
    
    func cellSizeForSection(indexPath: IndexPath) -> CGSize {
        let tagValue: String
        
        switch indexPath.section {
        case 0:
            tagValue = tagStorage.locationTags[indexPath.item].value
        case 1:
            tagValue = tagStorage.themeTags[indexPath.item].value
        case 2:
            tagValue = tagStorage.keywordTags[indexPath.item].value
        default:
            return .zero
        }
        
        return calculateSizeForCharacters(tagValue: tagValue)
    }
    
    // MARK: Private
    
    private func bind() {
        tagStorage.didChangeTags = { [weak self] in
            self?.handleTagSelectionChange()
        }
    }
    
    private func handleTagSelectionChange() {
        guard let selectedTagsCount = self.getSelectedTags()?.count else { return }
        let hasRequiredTagCount = selectedTagsCount >= 2
        
        self.updateSubmitButtonState(hasRequiredTagCount)
    }
    
    private func calculateSizeForCharacters(tagValue: String) -> CGSize {
        let font = UIFont.systemFont(ofSize: Font.bodyBold.fontSize, weight: Font.bodyBold.weight)
        let tagValueSize = (tagValue as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        
        let padding: CGFloat = 48.05
        let defaultHeight: CGFloat = 47.0

        let widthResult = tagValueSize.width + padding
        
        return CGSize(width: widthResult, height: defaultHeight)
    }
}
