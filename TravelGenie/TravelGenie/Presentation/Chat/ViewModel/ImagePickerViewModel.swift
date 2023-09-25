//
//  ImagePickerViewModel.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/07.
//

import Foundation

protocol ImagePickerDelegate: AnyObject {
    func photoDataSent(_ data: [Data])
}

final class ImagePickerViewModel {
    
    weak var delegate: ImagePickerDelegate?
    var selectedPhotoCountChanged: ((Int) -> Void)?
    
    private(set) var selectedPhotos: [IndexPath] = [] {
        didSet {
            selectedPhotoCountChanged?(selectedPhotos.count)
        }
    }
    
    func addImage(at indexPath: IndexPath) {
        selectedPhotos.append(indexPath)
    }
    
    func removeImage(at indexPath: IndexPath) {
        selectedPhotos = selectedPhotos.filter { $0 != indexPath }
    }
    
    func selectedIndexForCurrentPhoto(at indexPath: IndexPath) -> Int? {
        let index = selectedPhotos.firstIndex { selectedIndex in
            return indexPath == selectedIndex
        }
        
        if let index { return index + 1 }
        
        return nil
    }
    
    func sendPhotos(data: [Data]) {
        delegate?.photoDataSent(data)
    }
}
