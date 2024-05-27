//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 12.10.23.
//

import Foundation

// MARK: - Protocol

public protocol WebViewPresenterProtocol {
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
    var view: WebViewViewControllerProtocol? { get set }
}

// MARK: - Class

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Public properties
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    // MARK: - Init
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - Methods
    
    func viewDidLoad() {
        let request = authHelper.authRequest()
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    // non-private for Unit testing
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
