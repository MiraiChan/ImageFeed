//
//  ProfileStructures.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 24.09.23.
//

import Foundation

// MARK: - Struct

public struct Profile {
    let username: String
    public let name: String
    public let loginName: String
    public let bio: String?
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
}


// MARK: - Init for ProfileResult

extension Profile {
    
    init(result profile: ProfileResult) {
        self.init(
            username: profile.username,
            name: "\(profile.firstName ?? "") \(profile.lastName ?? "")",
            loginName: "@\(profile.username)",
            bio: profile.bio ?? "User didn't fill biography box."
        )
    }
}
