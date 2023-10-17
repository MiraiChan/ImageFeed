//
//  PhotoStructures.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 28.09.23.
//

import Foundation

public struct Photo {
    public let id: String
    public let size: CGSize
    public let createdAt: Date?
    public let welcomeDescription: String?
    public let thumbImageURL: String
    public let largeImageURL: String
    public var isLiked: Bool
    public let thumbSize: CGSize
}

struct UrlsResult: Codable {
  let small: String
  let full: String
}

struct LikeResult: Codable {
  let photo: PhotoLikeResult
}

struct PhotoLikeResult: Codable {
  let likedByUser: Bool
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
