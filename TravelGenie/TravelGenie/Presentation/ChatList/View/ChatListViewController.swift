//
//  ChatListViewController.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/20.
//

import UIKit

final class ChatListViewController: UIViewController {
    
    private let viewModel: ChatListViewModel
    private let chatListTableView = UITableView()
    
    init(viewModel: ChatListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    private func configureViewController() {
        view.backgroundColor = .white
    }
    
    private func configureSubviews() {
        configureChatListTableView()
    }
    
    private func configureChatListTableView() {
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.backgroundColor = .clear
        chatListTableView.separatorStyle = .none
        chatListTableView.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.identifier)
    }
    
    private func configureHierarchy() {
        view.addSubview(chatListTableView)
    }
    
    private func configureLayout() {
        chatListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chatListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chatListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chatListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatListCell.identifier,
            for: indexPath) as? ChatListCell else { return UITableViewCell() }
        
        cell.configureContents(with: viewModel.chats[indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let icon: UIImage? = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20)).image { _ in
            UIImage(named: "trash")?
                .withTintColor(.white)
                .draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, handler in
            self?.viewModel.deleteItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            handler(true)
        }
        
        deleteAction.image = icon
        deleteAction.backgroundColor = .alert
            
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
}
