//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 04.09.23.
//

import Foundation

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
    
    func authTokenRequest(code: String) -> URLRequest? {
        return requestBuilder.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AuthConfiguration.standard.accessKey)"
            + "&&client_secret=\(AuthConfiguration.standard.secretKey)"
            + "&&redirect_uri=\(AuthConfiguration.standard.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=\(AuthConfigConstants.tokenRequestGrantTypeString)",
            httpMethod: AuthConfigConstants.postMethodString,
            baseURLString: AuthConfigConstants.baseURLString
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
            guard let self else { return }
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
