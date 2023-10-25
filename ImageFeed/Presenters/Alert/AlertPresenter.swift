//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 22.09.23.
//

import UIKit

// MARK: - Protocol

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(for result: AlertModel)
}

// MARK: - Class

final class AlertPresenter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}

// MARK: - AlertPresenterProtocol

extension AlertPresenter: AlertPresenterProtocol {
    
    func showAlert(for result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Alert"
        
        let alertAction = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion?()
        }
        alert.addAction(alertAction)
        
        if let secondButtonText = result.secondButtonText {
            let secondAction = UIAlertAction(title: secondButtonText, style: .default) { _ in
                result.secondCompletion?()
            }
            alert.addAction(secondAction)
        }
        
        if var topController = UIApplication.shared.windows[0].rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true)
        }
    }
}
