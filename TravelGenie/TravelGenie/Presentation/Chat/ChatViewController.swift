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
    enum MessagesDefaultSection: Int {
        case systemMessage = 0
        case welcomeMessage = 2
    }
    
    private let viewModel: ChatViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageList = Message.MockMessage
        messagesCollectionView.reloadData()
        title = "채팅"
    }
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Datasource error")
        }
        
        // Very important to check this when overriding `cellForItemAt`
        // Super method will handle returning the typing indicator cell
        guard !isSectionReservedForTypingIndicator(indexPath.section) else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        if let defaultSection = MessagesDefaultSection(rawValue: indexPath.section) {
            switch defaultSection {
            case .systemMessage:
                return messagesCollectionView.dequeueReusableCell(SystemMessageCell.self, for: indexPath)
            case .welcomeMessage:
                let cell = messagesCollectionView.dequeueReusableCell(ButtonCell.self, for: indexPath)
                cell.delegate = self
                return cell
            }
        }

        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    override func didTapButton(in _: UICollectionViewCell) {
        presentPHPicekrViewController()
    }
    
    private func insertPhotoMessage(image: UIImage, sender: SenderType) {
        let message = Message(image: image, sender: sender, messageId: UUID().uuidString, sentDate: Date())
        
        insertMessage(message)
    }
        
    private func insertMessage(_ message: Message) {
        messageList.append(message)
        
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
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
                self.getImage(results: results) { image in
                    guard let image else { return }
                    self.insertPhotoMessage(image: image, sender: self.defaultSender)
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
