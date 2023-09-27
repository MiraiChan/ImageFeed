//
//  URLRequestExtension.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 05.09.23.
//

import Foundation
import UIKit

final class URLRequestBuilder {
    
    static let shared = URLRequestBuilder()
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    func makeHTTPRequest(path: String, httpMethod: String? = nil, baseURLString: String? = nil) -> URLRequest? {
        
        guard
            let url = URL(string: baseURLString ?? "https://api.unsplash.com/me"),
            let baseURL = URL(string: path, relativeTo: url)
        else { return nil }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = httpMethod ?? "GET"
        if let token = oauth2TokenStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
