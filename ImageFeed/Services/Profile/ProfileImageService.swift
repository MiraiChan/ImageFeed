//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 17.09.23.
//

import Foundation
import UIKit

final class ProfileImageService {
    
    // MARK: - Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private let urlSession = URLSession.shared
    private let requestBuilder = URLRequestBuilder.shared
    
    private var task: URLSessionTask?
    private (set) var avatarURL: URL?
    
    private init() {}
}

private extension ProfileImageService {
    
    func makeRequest(userName: String) -> URLRequest? {
        requestBuilder.makeHTTPRequest(path: "/users/\(userName)")
    }
}
extension ProfileImageService {
    
    func fetchProfileImageURL(userName: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        task?.cancel()
        
        guard let request = makeRequest(userName: userName) else {
            assertionFailure("Invalid request")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let dataTask = urlSession.objectTask(for: request) {
            [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            self.task = nil
            
            switch result {
            case .success(let profileResult):
                guard let mediumPhoto = profileResult.profileImage?.medium else { return }
                self.avatarURL = URL(string: mediumPhoto)
                completion(.success(mediumPhoto))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo:  ["URL": mediumPhoto]
                )
            case .failure(_):
                completion(.failure(ProfileServiceError.invalidData))
            }
            self.task = nil
        }
        self.task = dataTask
        dataTask.resume()
    }
}

