//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 22.09.23.
//

import Foundation

struct AlertModel {
  let title: String
  let message: String
  let buttonText: String
  let completion: (() -> Void)?
}
