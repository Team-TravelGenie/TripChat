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
    }

}
