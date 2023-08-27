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
        contentView?.textViewDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureHierarchy()
        configureContentViewLayout(contentView)
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    private func configureHierarchy() {
        view.addSubview(contentView)
    }
    
    private func configureContentViewLayout(_ contentView: PopUpContentView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: 351),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension PopUpViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.attributedText = nil
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.attributedText = FeedbackTextView.placeholderText
        }
    }
}
    }
}
