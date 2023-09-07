//
//  UIView+InputItem.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/06.
//

import InputBarAccessoryView
import UIKit

extension UIView: InputItem {
    public var inputBarAccessoryView: InputBarAccessoryView? {
        get {
            return InputBarAccessoryView()
        }
        set(newValue) {
            return
        }
    }
    
    public var parentStackViewPosition: InputStackView.Position? {
        get {
            return .bottom
        }
        set(newValue) {
            return
        }
    }
    
    public func textViewDidChangeAction(with textView: InputTextView) { }
    
    public func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) { }
    
    public func keyboardEditingEndsAction() { }
    
    public func keyboardEditingBeginsAction() { }
    
    
}
