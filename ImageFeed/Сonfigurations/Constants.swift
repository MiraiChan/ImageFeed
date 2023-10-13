//
//  Constants.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 25.08.23.
//

import Foundation

enum Constants {
    // MARK: - Unsplash API constants for app
    static let accessKey = "xHdiZjeVewTI-J6qKZGZFImsyvTndYog9M94OBkOELQ"
    static let secretKey = "OxUia9bRGuv01C_Al6uKbgNCrnshrQP5TjmRMbW5Al8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"

    // MARK: - Unsplash base URLs
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
//MARK: - DateFormatter

let longDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "d MMMM YYYY"
    return df
}()

