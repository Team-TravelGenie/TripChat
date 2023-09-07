//
//  CustomImagePickerViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/07.
//

import Foundation

protocol ImagePickerDelegate: AnyObject {
    func photoDataSent(_ data: [Data])
}

final class CustomImagePickerViewModel {
    
    weak var delegate: ImagePickerDelegate?
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
    
    func sendPhotos() {
        let photos = selectedPhotos.compactMap { $0 }
        delegate?.photoDataSent(photos)
    }
}
