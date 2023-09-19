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
        collectionView.delegate = self
        collectionView.dataSource = self
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
                    self?.presentPhotoAuthorizationDeniedAlert()
                    return
                default:
                    return
                }
            }
        }
    }
}

extension CustomImagePickerViewController: CustomImagePickerHeaderViewDelegate {
    func dismissModal() {
        dismiss(animated: false)
    }
    
    func send() {
        viewModel.sendPhotos()
        dismiss(animated: false)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension CustomImagePickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize
    {
        let width = (view.frame.width - 2) / 3
        let height = width
        return CGSize(width: width, height: height)
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

extension CustomImagePickerViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int)
        -> Int
    {
        return photos?.count ?? .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomImagePickerCell.identifier,
            for: indexPath) as? CustomImagePickerCell,
              let asset = photos?.object(at: indexPath.item)
        else { return UICollectionViewCell() }
        
        cell.assetIdentifier = asset.localIdentifier
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: thumbnailSize,
            contentMode: .aspectFill,
            options: nil) { (image, _) in
                if cell.assetIdentifier == asset.localIdentifier {
                    cell.setImage(image: image)
                }
            }
        
        if let count = viewModel.isSelected(selectedIndexPath: indexPath) {
            cell.configureSelectedState(count)
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath)
    {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomImagePickerCell,
              let imageData = cell.image()?.pngData()
        else { return }
        
        viewModel.addImage(indexPath: indexPath, imageData: imageData)
        cell.configureSelectedState(viewModel.selectedPhotos.count)
        
        if viewModel.selectedPhotos.count == 3 {
            guard let cells = collectionView.visibleCells as? [CustomImagePickerCell] else { return }
            
            cells.forEach {
                if !$0.isSelected { $0.layer.opacity = 0.2 }
            }
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath)
    {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomImagePickerCell else { return }
        
        viewModel.removeImage(at: indexPath)
        cell.configureDeselectedState(viewModel.selectedPhotos.count)
        
        if !viewModel.selectedPhotos.isEmpty {
            viewModel.selectedPhotos.forEach {
                guard let cell = collectionView.cellForItem(at: $0.indexPath) as? CustomImagePickerCell,
                      let index = viewModel.isSelected(selectedIndexPath: $0.indexPath)
                else { return }
                
                cell.configureSelectedState(index)
            }
        }
        
        if viewModel.selectedPhotos.count < 3 {
            guard let cells = collectionView.visibleCells as? [CustomImagePickerCell] else { return }
            
            cells.forEach {
                if !$0.isSelected { $0.layer.opacity = 1 }
            }
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath)
        -> Bool
    {
        guard viewModel.selectedPhotos.count < 3 else {
            self.presentPhotoLimitAlert()
            
            return false
        }
        
        return true
    }
}

// MARK: Alerts

extension CustomImagePickerViewController {
    private func presentPhotoAuthorizationDeniedAlert() {
        let alertController = UIAlertController(
            title: "사진 접근 권한 필요",
            message: "사진을 올리기 위해서는 사진 접근 권한이 필요합니다. '설정'에서 사진 접근 권한을 허용해주세요.",
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
            message: "사진은 3장 까지만 업로드 가능합니다.",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(action)
        self.present(alertController, animated: false)
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
