//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 30.08.23.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject {
  var presenter: WebViewPresenterProtocol? { get set }
  func load(request: URLRequest)
  func setProgressValue(_ newValue: Float)
  func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet var progressView: UIProgressView!
    
    // MARK: - Public properties
    
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        progressObservation()
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    // MARK: - Private methods
    
    func setupProgress() {
       progressView.progressTintColor = .ypBlack
       progressView.trackTintColor = .ypGray
       progressView.progressViewStyle = .bar
       progressView.setProgress(0, animated: true)
     }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    private func progressObservation() {
        estimatedProgressObservation = webView.observe (\.estimatedProgress, changeHandler: { [weak self] _, _ in
            guard let self else { return }
            self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
        })
    }
}


// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
