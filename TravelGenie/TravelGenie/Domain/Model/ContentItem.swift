//
//  ContentItem.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/20.
//

import UIKit
import MessageKit

// MARK: Content Item(s)

// MessageKind - .photo 메시지 컨텐츠
struct ImageMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        size = CGSize(width: 240, height: 240) // 사진별로 사이즈 달라지도록 설정해줘야할 듯?
        placeholderImage = UIImage()
    }
}

// MessageKind - .custom(TagItem) 메시지 컨텐츠
struct TagItem {
    var text: String
    var tags: [Tag]
    
    init(text: String, tags: [Tag]) {
        self.text = text
        self.tags = tags
    }
}

