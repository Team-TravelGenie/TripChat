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
    private let termsOfUsageView = InformationMenuView()
    private let privacyView = InformationMenuView()
    private let lineView = LineView()
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
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
        configureHierarchy()
        configureLayout()
    }
        
    // MARK: Private
    
    private func configureSubviews() {
        configureMainTextView()
        configureBodyTextView()
        configureChatButton()
        configureChatListButton()
        configureLineView()
        configureInformationMenu()
    }
    
    private func configureHierarchy() {
        [mainTextView, bodyTextView, chatButton, chatListButton, informationStackView].forEach { view.addSubview($0) }
        [termsOfUsageView, lineView, privacyView].forEach { informationStackView.addArrangedSubview($0) }
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
        
        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            informationStackView.topAnchor.constraint(equalTo: chatButton.bottomAnchor, constant: 52),
            informationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            informationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        termsOfUsageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            termsOfUsageView.heightAnchor.constraint(equalToConstant: 56),
        ])
        
        privacyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            privacyView.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
    
    private func configureMainTextView() {
        mainTextView.isScrollEnabled = false
        mainTextView.attributedText = NSMutableAttributedString()
            .text("AI", font: .largeTitle, color: .primary)
            .text("와 함께\n", font: .largeTitle, color: .black)
            .text("여행", font: .largeTitle, color: .primary)
            .text(" 하실래요?", font: .largeTitle, color: .black)
    }
    
    private func configureBodyTextView() {
        bodyTextView.isScrollEnabled = false
        bodyTextView.attributedText = NSMutableAttributedString()
            .text("오늘은 어디로 여행을 떠나고 싶나요?\n", font: .bodyRegular, color: .grayFont)
            .text("사진을 보내주시면 추천 해 드릴게요!", font: .bodyRegular, color: .grayFont)
    }
    
    private func configureChatButton() {
        let chatButtonTitle = NSMutableAttributedString()
            .text("채팅하기", font: .headline, color: .black)
        chatButton.setImage(UIImage(named: "chat"), for: .normal)
        chatButton.setAttributedTitle(chatButtonTitle, for: .normal)
    }
    
    private func configureChatListButton() {
        let chatListButtonTitle = NSMutableAttributedString()
            .text("최근대화", font: .headline, color: .black)
        chatListButton.setImage(UIImage(named: "search"), for: .normal)
        chatListButton.setAttributedTitle(chatListButtonTitle, for: .normal)
    }
    
    private func configureLineView() {
        lineView.setLineWith(color: .blueGrayLine, weight: 1)
    }
    
    private func configureInformationMenu() {
        termsOfUsageView.setTitle(with: "서비스 이용약관")
        privacyView.setTitle(with: "개인정보처리방침")
    }
}
