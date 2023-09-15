//
//  TagMessageInteractionState.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/15.
//

import Foundation

struct TagMessageInteractionState {
    var submitButtonState: Bool
    var interactionState: Bool
    
    init(submitButtonState: Bool = false, interactionState: Bool = true) {
        self.submitButtonState = submitButtonState
        self.interactionState = interactionState
    }
}
