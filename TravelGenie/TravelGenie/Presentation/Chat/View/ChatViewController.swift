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
        bind()
        chatViewModel.inputBarStateDelegate = self
        chatViewModel.buttonStateDelegate = chatInterfaceViewModel
        chatViewModel.messageStorageDelegate = chatInterfaceViewModel
        scrollsToLastItemOnKeyboardBeginsEditing = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        configureMessageInputBar()
        super.viewDidLoad()
        setupNavigation()
        chatViewModel.setupDefaultSystemMessages()
    }
    
    // MARK: Private
    
    private func bind() {
        chatViewModel.didTapImageUploadButton = { [weak self] in
            self?.showImagePicker()
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
        let backBarButtonImage = UIImage(systemName: DesignAssetName.backButtonImage)
        
        return UIAction(image: backBarButtonImage) { [weak self] _ in
            guard let self else { return }
            let popUpModels = self.chatViewModel.backButtonTapped()
            self.showPopUp(
                viewModel: popUpModels.viewModel,
                type: popUpModels.type,
                delegate: self)
        }
    }
    
    private func configureMessageInputBar() {
        let customInputBar = CustomInputBarAccessoryView()
        customInputBar.inputBarButtonDelegate = self
        customInputBar.separatorLine.isHidden = true
        customInputBar.delegate = chatViewModel
        inputBarType = .custom(customInputBar)
    }
}

// MARK: CustomImagePicker

extension ChatViewController {
    private func showImagePicker() {
        let customImagePickerViewModel = CustomImagePickerViewModel()
        customImagePickerViewModel.delegate = chatViewModel
        let vc = CustomImagePickerViewController(viewModel: customImagePickerViewModel)
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        present(vc, animated: true)
    }
}

// MARK: PopUpViewControllerDelegate

extension ChatViewController: PopUpViewControllerDelegate {
    func saveChat() {
        chatViewModel.saveChat()
    }
    
    func pop() {
        chatViewModel.pop()
    }
}

// MARK: CustomInputBarAccessoryViewDelegate

extension ChatViewController: CustomInputBarAccessoryViewDelegate {
    func photosButtonTapped() {
        showImagePicker()
    }
}

extension ChatViewController: InputBarStateDelegate {
    func setPhotosButtonState(_ isEnabled: Bool) {
        guard let inputBar = messageInputBar as? CustomInputBarAccessoryView else { return }
        
        inputBar.updatePhotosButtonState(isEnabled)
    }
    
    func updateInputTextViewState(_ isEditable: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.messageInputBar.inputTextView.isEditable = isEditable
        }
    }
}
