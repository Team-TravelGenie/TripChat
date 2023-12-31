//
//  ContentItem.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/20.
//

import UIKit
import MessageKit

// MARK: Content Item(s)

// MARK: MessageKind - .photo 메시지 컨텐츠
struct ImageMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    var imageData: Data?
    
    init(url: URL?, image: UIImage? = nil, imageData: Data? = nil) {
        self.url = url
        placeholderImage = UIImage()
        
        if image == nil, imageData != nil {
            let imageFromData = UIImage(data: imageData!)
            self.image = imageFromData
            self.imageData = imageData
            size = imageFromData?.size ?? .init()
        } else if image != nil, imageData == nil {
            let dataFromImage = image?.pngData()
            self.image = image
            self.imageData = dataFromImage
            size = image!.size
        } else {
            size = .init()
        }
    }
}

// MARK: MessageKind - .custom(TagItem) 메시지 컨텐츠

struct TagItem: Codable {
    var tags: [Tag]
}

struct Tag: Codable {
    let category: Category
    let value: String
    var isSelected: Bool
    
    init(category: Category, value: String, isSelected: Bool = false) {
        self.category = category
        self.value = value
        self.isSelected = isSelected
    }
}

enum Category: String, Codable {
    case location
    case theme
    case keyword
}

// MARK: MessageKind - .custom(RecommendationItem) 메시지 컨텐츠

struct RecommendationItem: Codable {
    let country: String
    let spotKorean: String
    let spotEnglish: String
    let image: Data
}

// MARK: MessageKind - .custom(LoadingAnimationItem) 메시지 컨텐츠

struct LoadingAnimationItem { }
