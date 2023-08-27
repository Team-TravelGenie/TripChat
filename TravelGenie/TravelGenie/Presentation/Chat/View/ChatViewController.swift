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
    
    private let viewModel: ChatViewModel
    
    // MARK: Lifecycle
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        let message = Message(tags: [
            Tag(category: .theme, value: "아"),
            Tag(category: .theme, value: "아라"),
            Tag(category: .theme, value: "아라0라"),
            Tag(category: .theme, value: "아라아라"),
            Tag(category: .theme, value: "아라아라라"),
            Tag(category: .theme, value: "아라라라라라"),
        ])
        messageStorage.insertMessage(message)
                              
        var recommendations: [RecommendationItem] = []
        let image = UIImage(systemName: "chevron.left")!
        let data = image.pngData()!
        recommendations.append(RecommendationItem(country: "아이폰나라", city: "아이폰시", spot: "아이폰", image: data))
        recommendations.append(RecommendationItem(country: "아2폰나라", city: "아2폰시", spot: "아2폰", image: data))
        recommendations.append(RecommendationItem(country: "33333", city: "아이폰시", spot: "아이폰", image: data))
        let secondMessage = Message(recommendations: recommendations, sentDate: Date())
        messageStorage.insertMessage(secondMessage)
    }
    
    override func didTapImageUploadButton() {
        presentPHPicekrViewController()
    }
    
    // MARK: Private
    
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
            let popUpModels = self.viewModel.backButtonTapped()
            self.showPopUp(
                viewModel: popUpModels.viewModel,
                type: popUpModels.type,
                delegate: self)
        }
    }
}

// MARK: PHPickerViewControllerDelegate 관련
extension ChatViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if results.isEmpty {
            self.dismiss(animated: true)
        } else {
            self.dismiss(animated: true) {
                self.getImage(results: results) { [weak self] image in
                    guard let self,
                          let image else { return }
                    let message = self.viewModel.makePhotoMessage(image)
                    
                    self.messageStorage.insertMessage(message)
                }
            }
        }
    }
    
    private func presentPHPicekrViewController() {
        let configuration = setupPHPicekrConfiguration()
        let phPickerViewController = PHPickerViewController(configuration: configuration)
        
        phPickerViewController.delegate = self
        phPickerViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = phPickerViewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        present(phPickerViewController, animated: true)
    }
    
    private func setupPHPicekrConfiguration() -> PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .current
        configuration.selectionLimit = 1
        
        return configuration
    }
    
    private func getImage(results: [PHPickerResult], completion: @escaping (UIImage?) -> Void) {
        var formattedImage: UIImage?
        guard let itemProvider = results.first?.itemProvider else { return }
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        formattedImage = image as? UIImage
                        completion(formattedImage)
                    }
                }
            })
        }
    }
}

extension ChatViewController: PopUpViewControllerDelegate {
    func dismiss(viewController: UIViewController) {
        dismiss(animated: false)
    }
}
