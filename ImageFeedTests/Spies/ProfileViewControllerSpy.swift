//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Almira Khafizova on 15.10.23.
//


import Foundation
import UIKit.UILabel
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
  var presenter: ProfilePresenterProtocol?

  var viewDidUpdateAvatar = false
  var viewDidLoadProfile = false

  var label1 = UILabel()
  var label2 = UILabel()
  var label3 = UILabel()

  func updateAvatar(url: URL) {
    viewDidUpdateAvatar = true
  }

  func loadProfile(_ profile: Profile?) {
    viewDidLoadProfile = true
    if let profile {
      label1.text = profile.name
      label2.text = profile.loginName
      label3.text = profile.bio
    }
  }
}
