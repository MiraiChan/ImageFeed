//
//  NotificationExtensions.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 23.09.23.
//

import Foundation

// MARK: - Notification key for ProfileImage

extension Notification {
    
    static let userInfoImageURLKey: String = "URL"
    
    var userInfoImageURL: String? {
        userInfo?[Notification.userInfoImageURLKey] as? String
    }
}
