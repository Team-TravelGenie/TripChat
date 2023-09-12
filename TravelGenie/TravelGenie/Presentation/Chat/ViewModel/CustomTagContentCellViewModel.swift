//
//  CustomTagContentCellViewModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/25.
//

import Foundation

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

    private var submitButtonState: Bool = true {
        didSet {
            didTapSubmitButton?(submitButtonState)
        }
    }
    
    // MARK: Internal
    
    func insertTags(tags: [Tag]) {
        tagStorage.insertTags(tags)
    }
    
    func getSelectedTags() -> [Tag]? {
        guard let isSelectedTags = tagStorage.getSelectedTags() else {
            print("선택된 태그없음")
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
        switch indexPath.section {
        case 0:
            let numberofCharactoersInTag = CGFloat(tagStorage.locationTags[indexPath.item].value.count)
            
            return calculateSizeForCharacters(count: numberofCharactoersInTag)
        case 1:
            let numberOfCharactersInTag = CGFloat(tagStorage.themeTags[indexPath.item].value.count)
            
            return calculateSizeForCharacters(count: numberOfCharactersInTag)
            
        case 2:
            let numberOfCharactersInTag = CGFloat(tagStorage.keywordTags[indexPath.item].value.count)
            
            return calculateSizeForCharacters(count: numberOfCharactersInTag)
        default:
            break
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    // MARK: Private
    
    private func calculateSizeForCharacters(count: CGFloat) -> CGSize {
        let additionalWidthForOneCharacterSize: CGFloat = 13.0
        let defaultHeight: CGFloat = 47.0
        let defaultWidth: CGFloat = 48.0
        
        let widthResult = defaultWidth + (count * additionalWidthForOneCharacterSize)

        return CGSize(width: widthResult, height: defaultHeight)
    }   
}

