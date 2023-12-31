//
//  ImagePickerViewController.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/06.
//

import Photos
import UIKit

final class ImagePickerViewController: UIViewController {
    
    let viewModel: ImagePickerViewModel
    
    private let headerView = ImagePickerHeaderView()
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout())
    
    private var fetchResult: PHFetchResult<PHAsset>?
    private var thumbnailSize: CGSize = .zero
    
    // MARK: Lifecycle
    
    init(viewModel: ImagePickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        configureThumbnailSize()
        configurePhotoLibrary()
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    // MARK: Private
    
    private func bind() {
        viewModel.selectedPhotoCountChanged = { [weak self] count in
            self?.headerView.setLabelText(with: count)
            self?.headerView.changeSendButtonState(count > 0)
        }
    }
    
    private func configureThumbnailSize() {
        let width = (view.frame.width - CGFloat(Constant.photosPerRow - 1)) / CGFloat(Constant.photosPerRow)
        let height = width
        thumbnailSize = CGSize(width: width, height: height)
    }
    
    private func configurePhotoLibrary() {
        checkAuthorization()
        PHPhotoLibrary.shared().register(self)
        
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOption)
    }
    
    private func checkAuthorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .restricted, .denied:
                    self?.presentPhotoAuthorizationDeniedAlert()
                default:
                    return
                }
            }
        }
    }
    
    private func configureSubviews() {
        configureCollectionView()
        configureHeaderView()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.register(
            ImagePickerCell.self,
            forCellWithReuseIdentifier: ImagePickerCell.identifier)
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
}

extension ImagePickerViewController: ImagePickerHeaderViewDelegate {
    func dismissModal() {
        dismiss(animated: false)
    }
    
    func send() {
        let maxSize: Int = 1024
        let group = DispatchGroup()
        let selectedIndices = viewModel.selectedPhotos
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        
        var imageData: [Data] = []
        
        for index in selectedIndices {
            group.enter()
            guard let asset = fetchResult?.object(at: index.item) else { continue }
            
            let assetWidth = asset.pixelWidth
            let assetHeight = asset.pixelHeight
            var targetWidth = CGFloat(assetWidth)
            var targetHeight = CGFloat(assetHeight)
            
            if assetWidth > assetHeight {
                if assetWidth > maxSize {
                    targetWidth = CGFloat(maxSize)
                    targetHeight = CGFloat(maxSize * assetHeight / assetWidth)
                }
            } else {
                if assetHeight > maxSize {
                    targetHeight = CGFloat(maxSize)
                    targetWidth = CGFloat(maxSize * assetWidth / assetHeight)
                }
            }
            
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: CGSize(width: targetWidth, height: targetHeight),
                contentMode: PHImageContentMode.default,
                options: options) { image, info in
                    guard let data = image?.pngData() else { return }
                    imageData.append(data)
                    group.leave()
                }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.viewModel.sendPhotos(data: imageData)
            self?.dismiss(animated: false)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ImagePickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize
    {
        return thumbnailSize
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int)
        -> CGFloat
    {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int)
        -> CGFloat
    {
        return 1
    }
}

// MARK: UICollectionViewDataSource

extension ImagePickerViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int)
        -> Int
    {
        return fetchResult?.count ?? .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImagePickerCell.identifier,
            for: indexPath) as? ImagePickerCell,
              let asset = fetchResult?.object(at: indexPath.item)
        else { return UICollectionViewCell() }
        
        cell.assetIdentifier = asset.localIdentifier
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: thumbnailSize,
            contentMode: .aspectFill,
            options: nil) { [weak self] (image, _) in
                if cell.assetIdentifier == asset.localIdentifier {
                    cell.setImage(image: image)
                    
                    if let count = self?.viewModel.selectedIndexForCurrentPhoto(at: indexPath) {
                        cell.configureSelectedState(count)
                    }
                }
            }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath)
    {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImagePickerCell else { return }
        
        self.viewModel.addImage(at: indexPath)
        cell.configureSelectedState(viewModel.selectedPhotos.count)
        
        if viewModel.selectedPhotos.count == Constant.maximumSelectedPhotoCount {
            guard let cells = collectionView.visibleCells as? [ImagePickerCell] else { return }
            
            cells.forEach {
                if !$0.isSelected { $0.alpha = 0.2 }
            }
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath)
    {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImagePickerCell else { return }
        
        viewModel.removeImage(at: indexPath)
        cell.configureDeselectedState(viewModel.selectedPhotos.count)
        
        if !viewModel.selectedPhotos.isEmpty {
            viewModel.selectedPhotos.forEach {
                guard let cell = collectionView.cellForItem(at: $0) as? ImagePickerCell,
                      let index = viewModel.selectedIndexForCurrentPhoto(at: $0)
                else { return }
                
                cell.configureSelectedState(index)
            }
        }
        
        if viewModel.selectedPhotos.count < Constant.maximumSelectedPhotoCount {
            guard let cells = collectionView.visibleCells as? [ImagePickerCell] else { return }
            
            cells.forEach {
                if !$0.isSelected { $0.alpha = 1 }
            }
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath)
        -> Bool
    {
        guard viewModel.selectedPhotos.count < Constant.maximumSelectedPhotoCount else {
            self.presentPhotoLimitAlert()
            return false
        }
        
        return true
    }
}

// MARK: Alerts

extension ImagePickerViewController {
    private func presentPhotoAuthorizationDeniedAlert() {
        let alertController = UIAlertController(
            title: "사진 접근 권한 필요",
            message: "사진을 업로드하기 위해서는 사진 접근 권한이 필요합니다. '설정'에서 사진 접근 권한을 허용해주세요.",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.dismiss(animated: false)
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: false)
    }
    
    private func presentPhotoLimitAlert() {
        let alertController = UIAlertController(
            title: "사진 선택 가능 갯수 초과",
            message: "사진은 3장 까지만 업로드 할 수 있습니다.",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: false)
    }
}

// MARK: PHPhotoLibraryChangeObserver

extension ImagePickerViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let photos = fetchResult,
              let changes = changeInstance.changeDetails(for: photos) else { return }
        
        DispatchQueue.main.async {
            self.fetchResult = changes.fetchResultAfterChanges
            
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

// MARK: Constant

private extension ImagePickerViewController {
    enum Constant {
        static let maximumSelectedPhotoCount: Int = 3
        static let photosPerRow: Int = 3
    }
}
