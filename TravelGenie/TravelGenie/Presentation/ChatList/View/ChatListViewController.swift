//
//  ChatListViewController.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import UIKit

final class ChatListViewController: UIViewController {
    
    private let viewModel: ChatListViewModel
    private let searchBarContainerView = UIView()
    private let searchBarView = SearchBarView()
    private let chatListTableView = UITableView()
    private let emptyChatLabel = UILabel()
    
    // MARK: Lifecycle
    
    init(viewModel: ChatListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureViewController()
        configureSubviews()
        configureHierarchy()
        configureLayout()
        navigationController?.delegate = self
    }
    
    // MARK: Private
    
    private func bind() {
        viewModel.emptyChat = { [weak self] isChatsEmpty in
            self?.emptyChatLabel.isHidden = !isChatsEmpty
        }
        viewModel.chatsDelivered = { [weak self] chats in
            self?.chatListTableView.reloadData()
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = .white
    }
    
    private func configureSubviews() {
        configureNavigationBarTitle()
        configureSearchBar()
        configureChatListTableView()
        configureEmptyChatLabel()
    }
    
    private func configureSearchBar() {
        searchBarContainerView.backgroundColor = .clear
        searchBarView.setTextFieldDelegate(delegate: self)
    }
        
    private func configureNavigationBarTitle() {
        let titleLabel = UILabel()
        let titleText = NSMutableAttributedString()
            .text("최근대화", font: .headline, color: .black)
        titleLabel.attributedText = titleText
        navigationItem.titleView = titleLabel
    }
    
    private func configureChatListTableView() {
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.separatorStyle = .none
        chatListTableView.backgroundColor = .white
        chatListTableView.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.identifier)
    }
    
    private func configureEmptyChatLabel() {
        let labelText = NSMutableAttributedString()
            .text("최근대화가 없습니다", font: .bodyRegular, color: .grayFont)
        emptyChatLabel.attributedText = labelText
        emptyChatLabel.isHidden = !viewModel.chats.isEmpty
    }
    
    private func configureHierarchy() {
        [searchBarContainerView, chatListTableView, emptyChatLabel].forEach { view.addSubview($0) }
        searchBarContainerView.addSubview(searchBarView)
    }
    
    private func configureLayout() {
        searchBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBarContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBarContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: searchBarContainerView.topAnchor, constant: 16),
            searchBarView.bottomAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor, constant: -16),
            searchBarView.leadingAnchor.constraint(equalTo: searchBarContainerView.leadingAnchor, constant: 12),
            searchBarView.trailingAnchor.constraint(equalTo: searchBarContainerView.trailingAnchor, constant: -12),
        ])
        
        chatListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chatListTableView.topAnchor.constraint(equalTo: searchBarContainerView.bottomAnchor),
            chatListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chatListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chatListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        emptyChatLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyChatLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyChatLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 35)
        ])
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let icon: UIImage? = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20)).image { _ in
            UIImage(named: "trash")?
                .withTintColor(.white)
                .draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))}
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, handler in
            self?.viewModel.remove(at: indexPath.row)
            handler(true)}
        action.image = icon
        action.backgroundColor = .alert
        
        return action
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int
    {
        return viewModel.chats.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatListCell.identifier,
            for: indexPath) as? ChatListCell else { return UITableViewCell() }
        
        cell.configureContents(with: viewModel.chats[indexPath.row])
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath)
        -> CGFloat
    {
        return 84
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration?
    {
        let deleteAction = deleteAction(at: indexPath)
            
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath)
    {
        viewModel.didSelectChat(index: indexPath.row)
    }
}

// MARK: UITextFieldDelegate

extension ChatListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel.fireSearch(with: textField.text)
        return true
    }
}

extension ChatListViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController)
    -> UIViewControllerAnimatedTransitioning?
    {
        if operation == .pop {
            self.viewModel.coordinator?.finish()
        }
        
        return nil
    }
}
