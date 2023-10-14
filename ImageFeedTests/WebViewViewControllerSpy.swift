//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Almira Khafizova on 14.10.23.
//

import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var viewDidLoadRequest = false
    
    func load(request: URLRequest) {
        viewDidLoadRequest = true
    }
    
    func setProgressValue(_ newValue: Float) { }
    
    func setProgressHidden(_ flag: Bool) { }
}
