//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 04.09.23.
//

import Foundation

protocol OAuth2TokenStorageProtocol {
    var token: String? {get set}
}

private enum Keys: String {
    case token
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private let userDefaults = UserDefaults.standard
    
    internal var token: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: Keys.token.rawValue)
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.token.rawValue)
            }
        }
    }
}
