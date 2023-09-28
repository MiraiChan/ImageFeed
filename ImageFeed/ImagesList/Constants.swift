//
//  Constants.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 25.08.23.
//

import Foundation

// MARK: - Unsplash API constants for app
let AccessKey = "xHdiZjeVewTI-J6qKZGZFImsyvTndYog9M94OBkOELQ"
let SecretKey = "OxUia9bRGuv01C_Al6uKbgNCrnshrQP5TjmRMbW5Al8"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

// MARK: - Unsplash base URLs
let DefaultBaseURL = URL(string: "https://api.unsplash.com")
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

//MARK: - DateFormatter

let dateFormatter: DateFormatter = {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "d MMMM YYYY"
  return dateFormatter
} ()

