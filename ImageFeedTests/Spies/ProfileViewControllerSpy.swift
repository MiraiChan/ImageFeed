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
    
    var profileUserNameLabel = UILabel()
    var profileLoginNameLabel = UILabel()
    var profileBioLabel = UILabel()
    
    func updateAvatar(url: URL) {
        viewDidUpdateAvatar = true
    }
    
    func loadProfile(_ profile: Profile?) {
        viewDidLoadProfile = true
        if let profile {
            profileUserNameLabel.text = profile.name
            profileLoginNameLabel.text = profile.loginName
            profileBioLabel.text = profile.bio
        }
    }
}
