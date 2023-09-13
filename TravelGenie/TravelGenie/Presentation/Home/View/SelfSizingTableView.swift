//
//  SelfSizingTableView.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/12.
//

import UIKit

final class SelfSizingTableView: UITableView {

    override var intrinsicContentSize: CGSize {
        let height = contentSize.height + contentInset.top + contentInset.bottom
        
        return CGSize(width: self.contentSize.width, height: height)
    }
    
    override func layoutSubviews() {
        invalidateIntrinsicContentSize()
        super.layoutSubviews()
    }
}
