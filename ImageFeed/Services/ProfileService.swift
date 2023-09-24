//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 14.09.23.
//

import Foundation
import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    
    private var urlSession = URLSession.shared
    private let requestBuilder: URLRequestBuilder
    private var fetchProfileTask: URLSessionTask?
    private(set) var profile: Profile?
    
    init(urlSession: URLSession = .shared, requestBuilder: URLRequestBuilder = .shared) {
      self.urlSession = urlSession
      self.requestBuilder = requestBuilder
    }
  }

private extension ProfileService {

  func makeProfileRequest() -> URLRequest? {
    requestBuilder.makeHTTPRequest(path: "/me")
  }
}

extension ProfileService {
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        fetchProfileTask?.cancel()
        
        guard let request = makeProfileRequest() else {
            assertionFailure("Invalid request")
            completion(.failure(ProfileError.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        fetchProfileTask = session.objectTask(for: request) {
            [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { preconditionFailure("Cannot make weak link") }
            
            self.fetchProfileTask = nil
            switch result {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(_):
                completion(.failure(ProfileError.decodingFailed))
            }
        }
    }
}

    enum ProfileError: Error {
        case unauthorized
        case invalidData
        case invalidRequest
        case decodingFailed
    }
    
    private struct ProfileKeys {
        static let noBio = "User didn't fill biography box."
        static let noLastname = ""
    }

    
//    enum CodingKeys: String, CodingKey {
//        case username
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case bio
//    }


enum ProfileServiceError: Error {
    case invalidURL
    case invalidRequest
    case invalidData
    case decodingFailed
}
