//
//  TagMessageInteractionState.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/15.
//

import Foundation

struct TagMessageInteractionState {
    private (set) var submitButtonState: Bool
    private (set) var tagCollectionViewCellInteractionState: Bool
    
    init(submitButtonState: Bool = false, interactionState: Bool = true) {
        self.submitButtonState = submitButtonState
        self.tagCollectionViewCellInteractionState = interactionState
    }
}
