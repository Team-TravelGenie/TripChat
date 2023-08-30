//
//  ChatViewModel.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import UIKit

protocol MessageStorageDelegate: AnyObject {
    func insert(message: Message)
}

protocol ButtonStateDelegate: AnyObject {
    func setUploadButtonState(_ isEnabled: Bool)
}

final class ChatViewModel {
    
    weak var coordinator: ChatCoordinator?
    weak var delegate: MessageStorageDelegate?
    weak var buttonStateDelegate: ButtonStateDelegate?
    var didTapImageUploadButton: (() -> Void)?
    
    private let googleVisionUseCase: GoogleVisionUseCase
    private let visionResultProcessor = VisionResultProcessor()
    private let user: Sender = Sender(name: .user)
    
    // MARK: Lifecycle
    
    init(googleVisionUseCase: GoogleVisionUseCase) {
        self.googleVisionUseCase = googleVisionUseCase
        registerNotificationObservers()
    }
    
    // MARK: Internal
    
    func insertMessage(_ message: Message) {
        delegate?.insert(message: message)
    }
    
    func handlePhotoUploads(images: [UIImage]) {
        let totalPhotosToUpload = images.count
        var photoUploadCount = 0
        
        for image in images {
            let photoMessage = makePhotoMessage(from: image)
            
            insertMessage(photoMessage)
            photoUploadCount += 1
            
            if totalPhotosToUpload == photoUploadCount {
                updateUploadButtonState(false)
                extractKeywordsFromImages(images: images)
            }
        }
    }
    
    func backButtonTapped() -> (viewModel: PopUpViewModel, type: PopUpContentView.PopUpType) {
        let popUpViewModel = createPopUpViewModel()
        let popUpModel = createPopUpModel()
        
        return (viewModel: popUpViewModel, type: .normal(popUpModel))
    }
    
    func pop() {
        coordinator?.finish()
    }
    
    // MARK: Private
    
    private func makePhotoMessage(from image: UIImage) -> Message {
        return Message(
            image: image,
            sender: user,
            sentDate: Date())
    }
    
    private func makeTagMessage(from tags: [Tag]) -> Message {
        return Message(tags: tags)
    }

    private func updateUploadButtonState(_ isEnabled: Bool) {
        buttonStateDelegate?.setUploadButtonState(isEnabled)
    }
    
    private func extractKeywordsFromImages(images: [UIImage]) {
        let group = DispatchGroup()
        
        images.forEach {
            if let base64String = convertImageToBase64(image: $0) {
                
                group.enter()
                fetchKeywordsFromGoogleVision(base64String: base64String) {
                    group.leave()
                }
                
                group.enter()
                fetchLandMarksFromGoogleVision(base64String: base64String) {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            let tags = self.visionResultProcessor.getTopSixResults()
            let tagMessage = self.makeTagMessage(from: tags)
            
            self.delegate?.insert(message: tagMessage)
        }
    }

    private func convertImageToBase64(image: UIImage) -> String? {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            return imageData.base64EncodedString()
        }
        
        print("base64String 인코딩오류")
        return nil
    }

    private func fetchKeywordsFromGoogleVision(base64String: String, completion: @escaping () -> Void) {
        googleVisionUseCase.extractKeywords(base64String) { result in
            switch result {
            case .success(let keywords):
                self.visionResultProcessor.addKeywords(keywords.labels)
            case .failure(let error):
                print(error)
            }
            
            completion()
        }
    }
    
    private func fetchLandMarksFromGoogleVision(base64String: String, completion: @escaping () -> Void) {
        googleVisionUseCase.extractLandmarks(base64String) { result in
            switch result {
            case .success(let landmarks):
                self.visionResultProcessor.addLandmarks(landmarks.landmarks)
            case .failure(let error):
                print(error)
            }
            
            completion()
        }
    }
    
    private func requestRecommendations(with tags: [Tag]) {
        let keywords: [String] = tags.map { $0.value }
        // TODO: - ChatGPT에 keyword 넣어서 요청 보내기
    }
    
    private func createPopUpViewModel() -> PopUpViewModel {
        return PopUpViewModel()
    }
    
    private func createPopUpModel() -> PopUpModel {
        let mainText = NSMutableAttributedString()
            .text("대화를 종료하시겠습니까?\n", font: .bodyRegular, color: .black)
            .text("종료하시면 이 대화는 ", font: .bodyRegular, color: .black)
            .text("자동으로 종료", font: .bodyBold, color: .primary)
            .text("되니 주의 부탁 드려요!", font: .bodyRegular, color: .black)
        let leftButtonTitle = NSMutableAttributedString()
            .text("네", font: .bodyRegular, color: .white)
        let rightButtonTitle = NSMutableAttributedString()
            .text("아니요", font: .bodyRegular, color: .black)
        
        return PopUpModel(
            mainText: mainText,
            leftButtonTitle: leftButtonTitle,
            rightButtonTitle: rightButtonTitle)
    }
    
    private func registerNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTapImageUploadButton(notification:)),
            name: .imageUploadButtonTapped,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(submitSelectedTags(notification:)),
            name: .tagSubmitButtonTapped,
            object: nil)
    }
    
    // MARK: objc methods
    
    @objc private func didTapImageUploadButton(notification: Notification) {
        didTapImageUploadButton?()
    }

    @objc private func submitSelectedTags(notification: Notification) {
        guard let selectedTags = notification.userInfo?[NotificationKey.selectedTags] as? [Tag] else { return }
        requestRecommendations(with: selectedTags)
    }
}
