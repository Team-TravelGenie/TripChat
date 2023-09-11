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
    private lazy var feedbackContentViewOriginY: Double = feedbackContentView.frame.origin.y
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        registerObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        feedbackContentView.endFeedbackTextViewEditing()
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        configureFeedbackContentView()
    }
    
    private func configureFeedbackContentView() {
        feedbackContentView.delegate = self
        feedbackContentView.textViewDelegate = self
        feedbackContentView.isHidden = true
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
    
    private func registerObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(moveFeedbackContentViewUp),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(moveFeedbackContentViewDown),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    // MARK: objc methods
    
    @objc private func moveFeedbackContentViewUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self else { return }
                
                self.feedbackContentView.transform = CGAffineTransform(
                    translationX: 0,
                    y: self.feedbackContentViewOriginY - keyboardSize.height)
            }
        }
    }
    
    @objc private func moveFeedbackContentViewDown(_ notification: NSNotification) {
        self.feedbackContentView.transform = .identity
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
        feedbackContentView.isHidden = false
        endChatContentView.isHidden = true
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
