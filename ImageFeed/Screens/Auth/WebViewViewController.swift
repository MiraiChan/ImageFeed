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
        updateProgress()
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    // MARK: - Private methods
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    //private func webViewLoading () {
    }
    
    private func progressObservation() {
        estimatedProgressObservation = webView.observe (\.estimatedProgress, changeHandler: { [weak self] _, _ in
            guard let self else { return }
            self.updateProgress()
        })
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
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
