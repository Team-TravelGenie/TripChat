//
//  HomeViewController.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/14.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    
    private let mainTextView = UITextView()
    private let bodyTextView = UITextView()
    private let chatButton = HomeMenuButton()
    private let chatListButton = HomeMenuButton()
    private let lineView = LineView()
    
    // MARK: Lifecycle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureSubviews()
        configureLayout()
    }
        
    // MARK: Private
    
    private func configureSubviews() {
        configureMainTextView()
        configureBodyTextView()
        configureChatButton()
        configureChatListButton()
        configureLineView()
    }
    
    private func configureLayout() {
        mainTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            mainTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyTextView.topAnchor.constraint(equalTo: mainTextView.bottomAnchor),
            bodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chatButton.topAnchor.constraint(equalTo: bodyTextView.bottomAnchor, constant: 32),
            chatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        chatListButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chatListButton.topAnchor.constraint(equalTo: chatButton.topAnchor),
            chatListButton.leadingAnchor.constraint(equalTo: chatButton.trailingAnchor, constant: 12),
            chatListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chatListButton.widthAnchor.constraint(equalTo: chatButton.widthAnchor),
        ])
    }
    
    private func configureMainTextView() {
        mainTextView.isScrollEnabled = false
        mainTextView.attributedText = NSMutableAttributedString()
            .largeTitle("AI", color: .primary, weight: .bold)
            .largeTitle("와 함께\n", color: .black, weight: .bold)
            .largeTitle("여행", color: .primary, weight: .bold)
            .largeTitle(" 하실래요?", color: .black, weight: .bold)
    }
    
    private func configureBodyTextView() {
        bodyTextView.isScrollEnabled = false
        bodyTextView.attributedText = NSMutableAttributedString()
            .body("오늘은 어디로 여행을 떠나고 싶나요?\n", color: .grayFont, weight: .regular)
            .body("사진을 보내주시면 추천 해 드릴게요!", color: .grayFont, weight: .regular)
    }
    
    private func configureChatButton() {
        let chatButtonTitle = NSMutableAttributedString()
            .headline("채팅하기", color: .black, weight: .bold)
        chatButton.setImage(UIImage(named: "chat"), for: .normal)
        chatButton.setAttributedTitle(chatButtonTitle, for: .normal)
    }
    
    private func configureChatListButton() {
        let chatListButtonTitle = NSMutableAttributedString()
            .headline("최근대화", color: .black, weight: .bold)
        chatListButton.setImage(UIImage(named: "search"), for: .normal)
        chatListButton.setAttributedTitle(chatListButtonTitle, for: .normal)
    }
    
    private func configureLineView() {
        lineView.setLineWith(color: .blueGrayLine, weight: 1)
    }
}
