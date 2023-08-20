//
//  HomeViewController.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/14.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let planeImageView = UIImageView()
    private let mainTextView = UITextView()
    private let bodyTextView = UITextView()
    private let chatButton = HomeMenuButton()
    private let chatListButton = HomeMenuButton()
    private let bottomMenuTableView = UITableView(frame: .zero, style: .plain)
    private let coverView = UIView()
    
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
        bind()
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
        
    // MARK: Private
    
    private func bind() {
        viewModel.showBottomMenu = { [weak self] item in
            self?.showTermsDetail(item: item)
        }
    }
    
    private func configureSubviews() {
        configurePlaneImageView()
        configureMainTextView()
        configureBodyTextView()
        configureChatButton()
        configureChatListButton()
        configureBottomMenuTableView()
        configureCoverView()
    }
    
    private func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [planeImageView, mainTextView, bodyTextView, chatButton, chatListButton, bottomMenuTableView, coverView]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
        ])
        
        planeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            planeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            planeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        mainTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            mainTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
        
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyTextView.topAnchor.constraint(equalTo: mainTextView.bottomAnchor),
            bodyTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
        
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chatButton.topAnchor.constraint(equalTo: bodyTextView.bottomAnchor, constant: 32),
            chatButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
        
        chatListButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chatListButton.topAnchor.constraint(equalTo: chatButton.topAnchor),
            chatListButton.leadingAnchor.constraint(equalTo: chatButton.trailingAnchor, constant: 12),
            chatListButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chatListButton.widthAnchor.constraint(equalTo: chatButton.widthAnchor),
        ])
        
        bottomMenuTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomMenuTableView.topAnchor.constraint(equalTo: chatButton.bottomAnchor, constant: 52),
            bottomMenuTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bottomMenuTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bottomMenuTableView.heightAnchor.constraint(equalToConstant: 112),
        ])
        
        coverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverView.bottomAnchor.constraint(equalTo: bottomMenuTableView.bottomAnchor),
            coverView.leadingAnchor.constraint(equalTo: bottomMenuTableView.leadingAnchor),
            coverView.widthAnchor.constraint(equalTo: bottomMenuTableView.widthAnchor),
            coverView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    private func configurePlaneImageView() {
        let image = UIImage(named: "plane")
        planeImageView.image = image
    }
    
    private func configureMainTextView() {
        mainTextView.isEditable = false
        mainTextView.isScrollEnabled = false
        mainTextView.backgroundColor = .clear
        mainTextView.attributedText = NSMutableAttributedString()
            .text("AI", font: .largeTitle, color: .primary)
            .text("와 함께\n", font: .largeTitle, color: .black)
            .text("여행", font: .largeTitle, color: .primary)
            .text(" 하실래요?", font: .largeTitle, color: .black)
    }
    
    private func configureBodyTextView() {
        bodyTextView.isEditable = false
        bodyTextView.isScrollEnabled = false
        bodyTextView.backgroundColor = .clear
        bodyTextView.attributedText = NSMutableAttributedString()
            .text("오늘은 어디로 여행을 떠나고 싶나요?\n", font: .bodyRegular, color: .grayFont)
            .text("사진을 보내주시면 추천 해 드릴게요!", font: .bodyRegular, color: .grayFont)
    }
    
    private func configureChatButton() {
        let chatButtonTitle = NSMutableAttributedString()
            .text("채팅하기", font: .headline, color: .black)
        chatButton.setImage(UIImage(named: "chat"), for: .normal)
        chatButton.setAttributedTitle(chatButtonTitle, for: .normal)
        configureChatButtonAction()
    }
    
    private func configureChatButtonAction() {
        let action = UIAction { [weak self] _ in
            self?.viewModel.didTapNewChatButton()
        }
        chatButton.addAction(action, for: .touchUpInside)
    }
    
    private func configureChatListButton() {
        let chatListButtonTitle = NSMutableAttributedString()
            .text("최근대화", font: .headline, color: .black)
        chatListButton.setImage(UIImage(named: "search"), for: .normal)
        chatListButton.setAttributedTitle(chatListButtonTitle, for: .normal)
        configureChatListButtonAction()
    }
    
    private func configureChatListButtonAction() {
        let action = UIAction { [weak self] _ in
            self?.viewModel.didTapChatListButton()
        }
        chatListButton.addAction(action, for: .touchUpInside)
    }
    
    private func configureBottomMenuTableView() {
        bottomMenuTableView.delegate = self
        bottomMenuTableView.dataSource = self
        bottomMenuTableView.isScrollEnabled = false
        bottomMenuTableView.backgroundColor = .clear
        bottomMenuTableView.separatorColor = .blueGrayLine
        bottomMenuTableView.separatorInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        bottomMenuTableView.register(BottomMenuCell.self, forCellReuseIdentifier: BottomMenuCell.identifier)
    }
    
    private func configureCoverView() {
        coverView.backgroundColor = .white
    }
    
    private func showTermsDetail(item: BottomMenuItem) {
        // TODO: - 서비스 이용약관, 개인정보 처리방침 modal
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bottomMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BottomMenuCell.identifier, for: indexPath) as? BottomMenuCell else { return UITableViewCell() }
        cell.setTitle(with: viewModel.bottomMenus[indexPath.row].title)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapBottomMenuCell(at: indexPath.row)
    }
}
