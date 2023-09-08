//
//  PopUpViewController.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/26.
//

import UIKit

protocol PopUpViewControllerDelegate: AnyObject {
    func saveChat()
    func pop()
}

final class PopUpViewController: UIViewController {
    
    weak var delegate: PopUpViewControllerDelegate?
    
    private let viewModel: PopUpViewModel
    private var endChatContentView: PopUpContentView
    private var feedbackContentView: PopUpContentView
    
    // MARK: Lifecycle
    
    init(
        viewModel: PopUpViewModel,
        type: PopUpContentView.PopUpType,
        delegate: PopUpViewControllerDelegate)
    {
        self.viewModel = viewModel
        self.delegate = delegate
        let popUpModel = viewModel.createFeedbackModel()
        endChatContentView = PopUpContentView(type: type)
        feedbackContentView = PopUpContentView(type: .feedback(popUpModel))
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        endChatContentView.delegate = self
        endChatContentView.textViewDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        configureFeedbackContentView()
    }
    
    private func configureFeedbackContentView() {
        feedbackContentView.delegate = self
        feedbackContentView.textViewDelegate = self
    }
    
    private func configureHierarchy() {
        [endChatContentView, feedbackContentView].forEach { view.addSubview($0) }
    }
    
    private func configureLayout() {
        endChatContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            endChatContentView.widthAnchor.constraint(equalToConstant: 351),
            endChatContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endChatContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        feedbackContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedbackContentView.widthAnchor.constraint(equalToConstant: 351),
            feedbackContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedbackContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension PopUpViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.attributedText == FeedbackTextView.placeholderText else { return }
        textView.attributedText = nil
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.attributedText = FeedbackTextView.placeholderText
        }
    }
}

extension PopUpViewController: PopUpContentViewDelegate {
    
    func dismissPopUp() {
        dismiss(animated: false)
    }
    
    func showFeedbackContentView() {
    }
    
    func dismissAndPop() {
        dismiss(animated: false)
        delegate?.pop()
    }
    
    func saveChat() {
        delegate?.saveChat()
    }
    
    func sendFeedback(isPositive: Bool, content: String) {
        viewModel.sendUserFeedback(isPositive: isPositive, content: content)
    }
}
