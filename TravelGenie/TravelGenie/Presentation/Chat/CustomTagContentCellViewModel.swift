//
//  CustomTagContentCellViewModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/25.
//

import Foundation

final class CustomTagContentCellViewModel {
    private let tagStorage: TagStorage = TagStorage()
    
    var locationTagListCount: Int {
        return tagStorage.locationTagList.count
    }
    
    var themeTagListCount: Int {
        return tagStorage.themeTagList.count
    }
    
    var locationTagList: [MockTag] {
        return tagStorage.locationTagList
    }
    
    var themeTagList: [MockTag] {
        return tagStorage.themeTagList
    }
    
    var sectionsHeaderTexts: [String] {
        return ["✈️지역", "⛵️테마"]
    }
    
    // MARK: Internal
    
    func insertTags(tags: [MockTag]) {
        tagStorage.insertTags(tags)
    }
    
    func getSelectedTags() -> [MockTag]? {
        guard let isSelectedTags = tagStorage.getSelectedTags() else {
            print("선택된 태그없음")
            return nil
        }
        
        return isSelectedTags
    }
    
    func updateTagIsSelected(value: String, isSelected: Bool) {
        tagStorage.updateTagIsSelected(value: value, isSelected: isSelected)
    }
    
    func cellSizeForSection(indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            let numberofCharactoersInTag = CGFloat(tagStorage.locationTagList[indexPath.item].text.count)
            
            return calculateSizeForCharacters(count: numberofCharactoersInTag)
        case 1:
            let numberOfCharactersInTag = CGFloat(tagStorage.themeTagList[indexPath.item].text.count)
            
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

