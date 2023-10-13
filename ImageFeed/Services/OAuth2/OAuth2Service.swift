//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 04.09.23.
//

import Foundation
import UIKit

final class OAuth2Service {
    
    private var urlSession = URLSession.shared
    private var oauth2TokenStorage = OAuth2TokenStorage.shared
    private let requestBuilder: URLRequestBuilder
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    static let shared = OAuth2Service()
    
    private init(
        urlSession: URLSession = .shared,
        oauth2TokenStorage: OAuth2TokenStorage = .shared,
        requestBuilder: URLRequestBuilder = .shared
    ) {
        self.urlSession = urlSession
        self.oauth2TokenStorage = oauth2TokenStorage
        self.requestBuilder = requestBuilder
    }
    
    var isAuthenticated: Bool {
        oauth2TokenStorage.token != nil
    }
}

private extension OAuth2Service {
    struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
    }
}

private extension OAuth2Service {
    
    // Вспомогательная функция для получения своего профиля
    var selfProfileRequest: URLRequest? {
        requestBuilder.makeHTTPRequest(path: "/me", httpMethod: "GET")
    }
    
    /// Вспомогательная функция для получения картинки профиля
    func profileImageURLRequest(userName: String) -> URLRequest? {
        requestBuilder.makeHTTPRequest(
            path: "/users/\(userName)",
            httpMethod: "GET"
        )
    }
    
    /// Вспомогательная функция для получения картинок
    func photosRequest(page: Int, perPage: Int) -> URLRequest? {
        requestBuilder.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)"
            + "&&per_page=\(perPage)",
            httpMethod: "GET"
        )
    }
    
    /// Вспомогательная функция для получения лайкнутых картинок
    func likeRequest(photoId: String) -> URLRequest? {
        requestBuilder.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: "POST"
        )
    }
    
    /// Вспомогательная функция для получения не лайкнутых картинок
    func unlikeRequest(photoId: String) -> URLRequest? {
        requestBuilder.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: "DELETE"
        )
    }
    
    func authTokenRequest(code: String) -> URLRequest? {//Функция для создания URLRequest с заданным code.
        return requestBuilder.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURLString: "https://unsplash.com"
        )
    }
}


extension OAuth2Service {
    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard code != lastCode else { return }
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code) else {
            assertionFailure("Invalid request")
            completion(.failure(ProfileError.invalidRequest))
            return
        }
        
        task = urlSession.objectTask (for: request) {
            [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { preconditionFailure("Cannot make weak link") }
            self.task = nil
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.oauth2TokenStorage.token = authToken
                completion(.success(authToken))
                
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
        }
    }
}


