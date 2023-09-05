//
//  ChatHistoryViewController.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/09/04.
//

import UIKit

final class ChatHistoryViewController: ChatInterfaceViewController {

    private let historyViewModel: ChatHistoryViewModel
    
    init(historyViewModel: ChatHistoryViewModel) {
        self.historyViewModel = historyViewModel
        super.init(nibName: nil, bundle: nil)
        historyViewModel.delegate = chatInterfaceViewModel
        historyViewModel.buttonStateDelegate = chatInterfaceViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHistoryChatUI()
        setupNavigation()
    }
    
    private func initializeHistoryChatUI() {
        historyViewModel.insertChatMessages()
        historyViewModel.deactivateButtons()
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
            
            self.historyViewModel.coordinator?.finish()
        }
    }
}
