//
//  Color.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/15.
//

import UIKit

private enum Color {
    case primary
    case secondary
    case tertiary
    case black
    case grayFont
    case grayBackground
    case white
    case blueGrayFont
    case blueGrayLine
    case blueGrayBackground
    case blueGrayBackground2
    case blueGrayBackground3
    case alert
    
    var color: UIColor {
        guard let color = UIColor(named: String(describing: self)) else {
            return .black
        }
        
        return color
    }
}

extension UIColor {
    class var primary: UIColor { return Color.primary.color }
    class var secondary: UIColor { return Color.secondary.color }
    class var tertiary: UIColor { return Color.tertiary.color }
    class var black: UIColor { return Color.black.color }
    class var grayFont: UIColor { return Color.grayFont.color }
    class var grayBackground: UIColor { return Color.grayBackground.color }
    class var white: UIColor { return Color.white.color }
    class var blueGrayFont: UIColor { return Color.blueGrayFont.color }
    class var blueGrayLine: UIColor { return Color.blueGrayLine.color }
    class var blueGrayBackground: UIColor { return Color.blueGrayBackground.color }
    class var blueGrayBackground2: UIColor { return Color.blueGrayBackground2.color }
    class var blueGrayBackground3: UIColor { return Color.blueGrayBackground3.color }
    class var alert: UIColor { return Color.alert.color }
}
