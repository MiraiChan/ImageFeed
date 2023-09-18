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
    private(set) var profile: Profile?
    
    private var fetchProfileTask: URLSessionTask?
    private let urlSession = URLSession.shared
    
    enum ProfileError: Error {
        case unauthorized
        case invalidData
        case decodingFailed
    }
    
    private struct ProfileKeys {
        static let noBio = "User didn't fill biography box."
        static let noLastname = ""
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        fetchProfileTask?.cancel()
        
        let url = URL(string: "https://api.unsplash.com/me")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetchProfileTask = urlSession.objectTask(for: request) {[weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profile = Profile(username: profileResult.username,
                                      name: "\(profileResult.firstName) \(profileResult.lastName ?? ProfileKeys.noLastname)",
                                      loginName: "@\(profileResult.username)",
                                      bio: profileResult.bio ?? ProfileKeys.noBio )
                self?.profile = profile
                completion(.success(profile))
            case .failure(_):
                completion(.failure(ProfileError.decodingFailed))
                self?.profile = nil
            }
        }
        fetchProfileTask?.resume()
    }
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile: Codable {
    var username: String
    var name: String
    var loginName: String
    var bio: String?
}

enum ProfileServiceError: Error {
    case invalidURL
    case invalidData
    case decodingFailed
}
