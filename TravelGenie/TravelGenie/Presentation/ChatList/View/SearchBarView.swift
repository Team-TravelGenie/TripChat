//
//  SearchBarView.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/24.
//

import UIKit

final class SearchBarView: UIView {
    
    private let mainStackView = UIStackView()
    private let searchIconImageView = UIImageView()
    private let searchTextField = UITextField()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMainView()
        configureSubviews()
        configureHiearchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func setTextFieldDelegate(delegate: UITextFieldDelegate) {
        searchTextField.delegate = delegate
    }
    
    // MARK: Private
    
    private func configureMainView() {
        clipsToBounds = true
        backgroundColor = .grayBackground
        layer.borderWidth = 1
        layer.borderColor = UIColor.blueGrayLine.cgColor
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    private func configureSubviews() {
        configureMainStackView()
        configureSearchIconImageView()
        configureSearchTextField()
    }
    
    private func configureMainStackView() {
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        mainStackView.alignment = .center
    }
    
    private func configureSearchIconImageView() {
        let image = UIImage(named: "magnifier")
        searchIconImageView.image = image
    }
    
    private func configureSearchTextField() {
        let placeholderText = NSMutableAttributedString()
            .text("검색", font: .bodyRegular, color: .blueGrayFont)
        searchTextField.textColor = .black
        searchTextField.returnKeyType = .search
        searchTextField.attributedPlaceholder = placeholderText
    }
    
    private func configureHiearchy() {
        addSubview(mainStackView)
        [searchIconImageView, searchTextField].forEach { mainStackView.addArrangedSubview($0) }
    }
    
    private func configureLayout() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
        
        searchIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchIconImageView.widthAnchor.constraint(equalToConstant: 20),
            searchIconImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
