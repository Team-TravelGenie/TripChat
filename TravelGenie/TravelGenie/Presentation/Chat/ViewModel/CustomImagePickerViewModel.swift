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
    
    private(set) var selectedPhotos: [(indexPath: IndexPath, imageData: Data)] = [] {
        didSet {
            selectedPhotoCountChanged?(selectedPhotos.count)
        }
    }
    
    func addImage(indexPath: IndexPath, imageData: Data) {
        selectedPhotos.append((indexPath: indexPath, imageData: imageData))
    }
    
    func removeImage(at indexPath: IndexPath) {
        selectedPhotos = selectedPhotos.filter { $0.indexPath != indexPath }
    }
    
    func isSelected(selectedIndexPath: IndexPath) -> Int? {
        let index = selectedPhotos.firstIndex { (indexPath, _) in
            return selectedIndexPath == indexPath
        }
        
        if let index { return index + 1 }
        
        return nil
    }
    
    func sendPhotos() {
        let photos = selectedPhotos.compactMap { $0.imageData }
        delegate?.photoDataSent(photos)
    }
}
