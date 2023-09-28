//
//  PhotoStructures.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 28.09.23.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
  let id: String
  let width: Int
  let height: Int
  let createdAt: String?
  let description: String?
  var likedByUser: Bool
  let urls: UrlsResult
}
