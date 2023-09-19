//
//  HomeTextLogoView.swift
//  TravelGenie
//
//  Created by summercat on 2023/09/19.
//

import UIKit

final class HomeTextLogoView: UIView {

    let textLogoImageView = UIImageView()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLogoImageView)
        configureSubview()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        invalidateIntrinsicContentSize()
        super.layoutSubviews()
    }
    
    // MARK: Private
    
    private func configureSubview() {
        let textLogoImage = UIImage(named: DesignAssetName.homeNavigationTitleLogo)
        textLogoImageView.image = textLogoImage
        textLogoImageView.contentMode = .scaleAspectFit
    }
    
    private func configureLayout() {
        textLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLogoImageView.topAnchor.constraint(equalTo: topAnchor, constant: Design.titleLogoVerticalPadding),
            textLogoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Design.titleLogoVerticalPadding),
            textLogoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLogoImageView.heightAnchor.constraint(equalToConstant: Design.titleLogoHeight),
        ])
        
        if let imageSize = textLogoImageView.image?.size {
            let ratio = imageSize.width / imageSize.height
            let height = Design.titleLogoHeight
            let calculatedWidth = height * ratio
            textLogoImageView.widthAnchor.constraint(equalToConstant: calculatedWidth).isActive = true
        }
    }
}

private extension HomeTextLogoView {
    enum Design {
        static let titleLogoVerticalPadding: CGFloat = 8
        static let titleLogoHeight: CGFloat = 24
    }
}
