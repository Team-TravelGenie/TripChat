//
//  CustomImagePickerViewController.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/06.
//

import Photos
import UIKit

final class CustomImagePickerViewController: UIViewController {
    
    let viewModel: CustomImagePickerViewModel
    
    private let headerView = CustomImagePickerHeaderView()
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout())
    
    private var photos: PHFetchResult<PHAsset>?
    private var thumbnailSize: CGSize = .zero
    
    // MARK: Lifecycle
    
    init(viewModel: CustomImagePickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK: Override(s)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        configurePhotoLibrary()
        configureSubviews()
        configureHierarchy()
        configureLayout()

        let width = view.frame.width / 3
        let height = width
        thumbnailSize = CGSize(width: width, height: height)
    }
    
    // MARK: Private
    
    private func bind() {
        viewModel.selectedPhotoCountChanged = { [weak self] count in
            self?.headerView.setLabelText(with: count)
            self?.headerView.changeSendButtonState(count > 0)
        }
    }
    
    private func configureSubviews() {
        configureCollectionView()
        configureHeaderView()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.register(CustomImagePickerCell.self, forCellWithReuseIdentifier: CustomImagePickerCell.identifier)
    }
    
    private func configureHeaderView() {
        headerView.delegate = self
        headerView.setLabelText(with: 0)
    }
    
    private func configureHierarchy() {
        [headerView, collectionView].forEach { view.addSubview($0) }
    }
    
    private func configureLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 64),
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func configurePhotoLibrary() {
        checkAuthorization()
        PHPhotoLibrary.shared().register(self)
        
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        photos = PHAsset.fetchAssets(with: .image, options: fetchOption)
    }
    
    private func checkAuthorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .restricted, .denied:
                    // TODO: - alert 보여주기
                    return
                default:
                    return
                }
            }
        }
    }
}

// MARK: PHPhotoLibraryChangeObserver

extension CustomImagePickerViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let photos = photos,
              let changes = changeInstance.changeDetails(for: photos) else { return }
        
        DispatchQueue.main.async {
            self.photos = changes.fetchResultAfterChanges
            
            if changes.hasIncrementalChanges {
                self.collectionView.performBatchUpdates {
                    if let removed = changes.removedIndexes,
                       !removed.isEmpty {
                        let indexPaths = removed.map { IndexPath(item: $0, section: .zero) }
                        self.collectionView.deleteItems(at: indexPaths)
                    }
                    
                    if let inserted = changes.insertedIndexes,
                       !inserted.isEmpty {
                        let indexPaths = inserted.map { IndexPath(item: $0, section: .zero) }
                        self.collectionView.insertItems(at: indexPaths)
                    }
                    
                    changes.enumerateMoves { from, to in
                        let fromIndexPath = IndexPath(item: from, section: .zero)
                        let toIndexPath = IndexPath(item: to, section: .zero)
                        self.collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
                    }
                    
                    if let changed = changes.changedIndexes,
                       !changed.isEmpty {
                        let indexPaths = changed.map { IndexPath(item: $0, section: .zero) }
                        self.collectionView.reloadItems(at: indexPaths)
                    }
                }
            } else {
                self.collectionView.reloadData()
            }
        }
    }
}
