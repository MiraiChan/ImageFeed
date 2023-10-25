//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 04.09.23.
//

import Foundation


struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
