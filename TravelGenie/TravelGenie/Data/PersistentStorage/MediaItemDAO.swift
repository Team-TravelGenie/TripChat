//
//  MediaItemDAO.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/23.
//

import Foundation
import MessageKit

struct MediaItemDAO: Codable {
    let urlString: String?
    let imageData: Data?
    let placeholderImageData: Data?
    let width: Double
    let height: Double
    
    init(with mediaItem: MediaItem) {
        urlString = mediaItem.url?.absoluteString
        imageData = mediaItem.image?.pngData()
        placeholderImageData = mediaItem.placeholderImage.pngData()
        width = mediaItem.size.width
        height = mediaItem.size.height
    }
}
