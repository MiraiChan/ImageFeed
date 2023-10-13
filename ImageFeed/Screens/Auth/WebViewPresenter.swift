//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 12.10.23.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        //Url
        guard var urlComponents = URLComponents(string: unsplashAuthorizeURLString)
        else {
            fatalError("Incorrect base URL")
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: accessScope)
        ]
        guard let url = urlComponents.url else {
            fatalError("Unable to build URL")
        }
        
        //URLRequest
        let request = URLRequest(url: url)
        view?.load(request: request)
    }
    
}
