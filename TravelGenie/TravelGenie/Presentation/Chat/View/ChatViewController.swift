//
//  ChatViewController.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import UIKit
import PhotosUI
import MessageKit

final class ChatViewController: ChatInterfaceViewController {
    
    private let chatViewModel: ChatViewModel
    
    // MARK: Lifecycle
    
    init(viewModel: ChatViewModel) {
        self.chatViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = chatInterfaceViewModel
        viewModel.buttonStateDelegate = chatInterfaceViewModel
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    // MARK: Private
    
    private func bind() {
        chatViewModel.didTapImageUploadButton = { [weak self] in
            self?.presentPHPickerViewController()
        }
    }
    
    private func setupNavigation() {
        setUpNavigationBarTitle()
        setUpNavigationBarBackButton()
    }
    
    private func setUpNavigationBarTitle() {
        let titleLabel = UILabel()
        let titleText = NSMutableAttributedString()
            .text("채팅", font: .headline, color: .black)
        titleLabel.attributedText = titleText
        navigationItem.titleView = titleLabel
    }
    
    private func setUpNavigationBarBackButton() {
        let backBarButton = UIBarButtonItem()
        backBarButton.primaryAction = createBackBarButtonAction()
        backBarButton.tintColor = .black
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    private func createBackBarButtonAction() -> UIAction {
        let backBarButtonImage = UIImage(systemName: "chevron.left")
        
        return UIAction(image: backBarButtonImage) { [weak self] _ in
            guard let self else { return }
            let popUpModels = self.chatViewModel.backButtonTapped()
            self.showPopUp(
                viewModel: popUpModels.viewModel,
                type: popUpModels.type,
                delegate: self)
        }
    }
}

// MARK: PHPickerViewControllerDelegate

extension ChatViewController: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult])
    {
        dismiss(animated: true) {
            self.getImages(results: results) { [weak self] in
                self?.chatViewModel.makePhotoMessages($0)
            }
        }
    }
    
    private func presentPHPickerViewController() {
        let configuration = setupPHPickerConfiguration()
        let phPickerViewController = PHPickerViewController(configuration: configuration)
        
        phPickerViewController.delegate = self
        phPickerViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = phPickerViewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        present(phPickerViewController, animated: true)
    }
    
    private func setupPHPickerConfiguration() -> PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .current
        configuration.selectionLimit = 3
        
        return configuration
    }
    
    private func getImages(
        results: [PHPickerResult],
        completion: @escaping ([UIImage]) -> Void)
    {
        var images: [UIImage] = []
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let error = error {
                    print(error.localizedDescription)
                } else if let image = image as? UIImage {
                    images.append(image)
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
}

// MARK: PopUpViewControllerDelegate

extension ChatViewController: PopUpViewControllerDelegate {
    func pop() {
        chatViewModel.pop()
    }
}
