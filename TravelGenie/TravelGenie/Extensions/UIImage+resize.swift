//
//  UIImage+resize.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/21.
//

import UIKit

extension UIImage {
    func resize(width: CGFloat, height: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: width, height: height)).image { _ in
                self.draw(in: CGRect(x: 0, y: 0, width: Int(width), height: Int(height)))
        }
    }
}
