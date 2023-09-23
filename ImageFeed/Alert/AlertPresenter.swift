//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 22.09.23.
//

import UIKit

// MARK: - Protocol

protocol AlertPresenting: AnyObject {
  func showAlert(for result: AlertModel)
}

// MARK: - Class

final class AlertPresenter {

  private weak var viewController: UIViewController?

  init(viewController: UIViewController?) {
    self.viewController = viewController
  }
}

// MARK: - AlertPresenting

extension AlertPresenter: AlertPresenting {

  func showAlert(for result: AlertModel) {
    let alert = UIAlertController(
      title: result.title,
      message: result.message,
      preferredStyle: .alert)
    let alertAction = UIAlertAction(title: result.buttonText, style: .default) { _ in
      result.completion?()
    }
    alert.addAction(alertAction)

    if var topController = UIApplication.shared.windows[0].rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      topController.present(alert, animated: true)
    }
  }
}

