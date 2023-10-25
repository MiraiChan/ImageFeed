//
//  Constants.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 25.08.23.
//

import Foundation

enum AuthConfigConstants {
    
    // MARK: - Unsplash API constants for app
    static let accessKey = "xHdiZjeVewTI-J6qKZGZFImsyvTndYog9M94OBkOELQ"
    static let secretKey = "OxUia9bRGuv01C_Al6uKbgNCrnshrQP5TjmRMbW5Al8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    // MARK: - Unsplash base URLs
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let baseURLString = "https://unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    // MARK: - Unsplash base AIP paths
    static let authorizedURLPath = "/oauth/authorize/native"
    static let tokenRequestPathString = "/oauth/token"
    static let profileRequestPathString = "/me"
    
    // MARK: - Request method's strings
    static let postMethodString = "POST"
    static let getMethodString = "GET"
    static let deleteMethodString = "DELETE"
    
    // MARK: - Storage constants
    static let tokenRequestGrantTypeString = "authorization_code"
    static let code = "code"
    static let bearerToken = "bearerToken"
}

    // MARK: - DateFormatter
    let longDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "d MMMM YYYY"
    return df
}()

