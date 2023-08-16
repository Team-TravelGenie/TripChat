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
}
