//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 04.09.23.
//

import Foundation
import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() { }
    
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode != code { return }
        task?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(body.accessToken))
                    self.task = nil
                    
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
}

private extension OAuth2Service {
    
    // Вспомогательная функция для получения своего профиля
    var selfProfileRequest: URLRequest {
        URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
    }
    
    /// Вспомогательная функция для получения картинки профиля
    func profileImageURLRequest(userName: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/users/\(userName)",
            httpMethod: "GET"
        )
    }
    
    /// Вспомогательная функция для получения картинок
    func photosRequest(page: Int, perPage: Int) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)"
            + "&&per_page=\(perPage)",
            httpMethod: "GET"
        )
    }
    
    /// Вспомогательная функция для получения лайкнутых картинок
    func likeRequest(photoId: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: "POST"
        )
    }
    
    /// Вспомогательная функция для получения не лайкнутых картинок
    func unlikeRequest(photoId: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: "DELETE"
        )
    }
    
    func authTokenRequest(code: String) -> URLRequest {//Функция для создания URLRequest с заданным code.
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}

