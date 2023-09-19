//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 04.09.23.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let keyChainStorage = KeychainWrapper.standard
    
    var token: String? {
        get {
            keyChainStorage.string(forKey: .tokenKey)
        }
        set {
            if let token = newValue {
                keyChainStorage.set(token, forKey: .tokenKey)
            } else {
                keyChainStorage.removeObject(forKey: .tokenKey)
            }
        }
    }
}

extension String {
    static let tokenKey = "bearerToken"
}
