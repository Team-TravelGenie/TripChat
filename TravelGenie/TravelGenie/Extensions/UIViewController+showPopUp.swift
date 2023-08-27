//
//  UIViewController+showPopUp.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/26.
//

import UIKit

extension UIViewController {
    func showPopUp(
        viewModel: PopUpViewModel,
        type: PopUpContentView.PopUpType,
        delegate: PopUpViewControllerDelegate)
    {
        let popUpViewController = PopUpViewController(
            viewModel: viewModel,
            type: type,
            delegate: delegate)
        present(popUpViewController, animated: false)
    }
}
