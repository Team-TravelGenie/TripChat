//
//  ChatListCell.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import UIKit

final class ChatListCell: UITableViewCell {
    
    static var identifier: String { String(describing: self) }

    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func configureContents(with item: Chat) {
    }
}
