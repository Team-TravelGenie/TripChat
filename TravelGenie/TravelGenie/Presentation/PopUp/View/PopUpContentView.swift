//
//  PopUpContentView.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/26.
//

import UIKit

protocol PopUpContentViewDelegate: AnyObject {
}

final class PopUpContentView: UIView {

    enum PopUpType {
        case normal(PopUpModel) // 콘텐트를 model로 받기
        case feedback(PopUpModel)
    }
    
    weak var delegate: PopUpContentViewDelegate?
    
    let type: PopUpType?
    
    // MARK: Lifecycle
    
    init(type: PopUpType) {
        self.type = type
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
