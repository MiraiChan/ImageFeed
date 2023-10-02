//
//  Constants.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 25.08.23.
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

//MARK: - DateFormatter

let dateFormatter: DateFormatter = {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "d MMMM YYYY"
  return dateFormatter
} ()

