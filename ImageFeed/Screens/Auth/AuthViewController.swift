//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 30.08.23.
//

import UIKit
import WebKit

// MARK: - Protocol

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

// MARK: - Class

final class AuthViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    @IBOutlet private weak var authButton: UIButton!
    
    // MARK: - Public properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        authButton.accessibilityIdentifier = "Authenticate"
    }
    
    // MARK: - Public methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else { preconditionFailure("Failed to prepare for \(showWebViewSegueIdentifier)") }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

