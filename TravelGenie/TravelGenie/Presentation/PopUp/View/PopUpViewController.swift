//
//  PopUpViewController.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/26.
//

import UIKit

protocol PopUpViewControllerDelegate: AnyObject {
}

final class PopUpViewController: UIViewController {
    
    weak var delegate: PopUpViewControllerDelegate?
    
    private let viewModel: PopUpViewModel!
    
    private var contentView: PopUpContentView!
    
    // MARK: Lifecycle
    
    init(
        viewModel: PopUpViewModel,
        type: PopUpContentView.PopUpType,
        delegate: PopUpViewControllerDelegate)
    {
        self.viewModel = viewModel
        self.delegate = delegate
        contentView = PopUpContentView(type: type)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        contentView?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
