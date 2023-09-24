//
//  Snake.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 23.09.23.
//
import Foundation

class SnakeCaseJSONDecoder: JSONDecoder {
  override init() {
    super.init()
    keyDecodingStrategy = .convertFromSnakeCase
  }
}
