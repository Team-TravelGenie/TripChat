//
//  LeftAlignedCollectionViewFlowLayout.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/20.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    let customMinimumInteritemSpacingForSectionAt: CGFloat = 8
    var totalHeight: CGFloat = 0 // 셀과 헤더 전체 높이를 계산하기 위한 변수

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = originAttributes.first?.frame.origin.y ?? 0
        
        let adjustAttributes = originAttributes.compactMap { originalAttribute -> UICollectionViewLayoutAttributes? in
            guard let layoutAttribute = originalAttribute.copy() as? UICollectionViewLayoutAttributes else { return nil }
            
            let isCell = layoutAttribute.representedElementCategory == .cell
            let isHeader = layoutAttribute.representedElementCategory == .supplementaryView
            
            if isCell {
                // 현재 셀의 new row를 그린 상태라면, 좌측 정렬하라.
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                
                layoutAttribute.frame.origin.x = leftMargin
                
                // 셀 너비와 항목 간 간격만큼 왼쪽 여백 증가
                let totalCellWidth = layoutAttribute.frame.width + customMinimumInteritemSpacingForSectionAt
                leftMargin += totalCellWidth
                
                // maxY 값 업데이트, 현재 행의 최대 y 위치를 추적
                maxY = max(layoutAttribute.frame.maxY, maxY)
                totalHeight = maxY
            }
            
            // totalHeight에 값을 더해주는 이유는 CustomTagContentCell의 messageContainer를 사이즈를 다시 그려주기 위해서입니다.
            if isHeader {
                totalHeight += layoutAttribute.frame.height
            }
            
            return layoutAttribute
        }
        
        return adjustAttributes
    }
}
