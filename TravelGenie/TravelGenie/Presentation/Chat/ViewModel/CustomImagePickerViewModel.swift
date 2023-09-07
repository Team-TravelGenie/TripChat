//
//  CustomImagePickerViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/07.
//

import Foundation

final class CustomImagePickerViewModel {
    
    var selectedPhotoCountChanged: ((Int) -> Void)?
    
    private(set) var selectedPhotos: [Data?] = [] {
        didSet {
            selectedPhotoCountChanged?(selectedPhotos.count)
        }
    }
    
    func addImage(data: Data?) {
        selectedPhotos.append(data)
    }
    
    func removeImage(data: Data?) {
        selectedPhotos = selectedPhotos.filter { $0 != data }
    }
    
    func isSelected(data: Data?) -> Int? {
        guard let index = selectedPhotos.firstIndex(of: data) else { return nil }
        
        return index + 1
    }
}
