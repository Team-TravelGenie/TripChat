//
//  ChatViewController.swift
//  TravelGenie
//
//  Created by 서현웅 on 2023/08/15.
//

import UIKit
import MessageKit

final class ChatViewController: ChatInterfaceViewController {

    private let viewModel: ChatViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageList = Message.MockMessage
        print(messageList)
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
}
