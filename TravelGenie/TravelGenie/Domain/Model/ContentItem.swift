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
        size = image.size // 디자인가이드를 현님에게 받아서 사이즈를 결정해야함
        placeholderImage = UIImage()
    }
}

// MessageKind - .custom(TagItem) 메시지 컨텐츠
struct TagItem {
    var tags: [Tag]
    
    init(tags: [Tag]) {
        self.tags = tags
    }
}

