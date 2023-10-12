//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 12.10.23.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
}
