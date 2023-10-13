//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 13.10.23.
//

import Foundation

// MARK: - Unsplash API constants for app
let accessKey = "xHdiZjeVewTI-J6qKZGZFImsyvTndYog9M94OBkOELQ"
let secretKey = "OxUia9bRGuv01C_Al6uKbgNCrnshrQP5TjmRMbW5Al8"
let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
let accessScope = "public+read_user+write_likes"

// MARK: - Unsplash base URLs
let defaultBaseURL = URL(string: "https://api.unsplash.com")
let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
    self.accessKey = accessKey
    self.secretKey = secretKey
    self.redirectURI = redirectURI
    self.accessScope = accessScope
    self.defaultBaseURL = defaultBaseURL
    self.authURLString = authURLString
    }
    
var standard: AuthConfiguration {
AuthConfiguration(
    accessKey: accessKey,
    secretKey: secretKey,
    redirectURI: redirectURI,
    accessScope: accessScope,
    authURLString: unsplashAuthorizeURLString,
    defaultBaseURL: defaultBaseURL)
    }
}

