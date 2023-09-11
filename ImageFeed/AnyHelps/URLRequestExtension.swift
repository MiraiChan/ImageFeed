//
//  URLRequestExtension.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 05.09.23.
//

import Foundation
import UIKit

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}
