//
//  CustomImagePickerViewController.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/06.
//

import Photos
import UIKit

final class CustomImagePickerViewController: UIViewController {
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout())
    
    private var photos: PHFetchResult<PHAsset>?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
