//
//  ProfilePresenter.swift
//  ImageFeedTests
//
//  Created by Almira Khafizova on 14.10.23.
//

import Foundation
import UIKit
import WebKit
import Kingfisher


protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func resetAccount()
}

final class ProfilePresenter {
    var view: ProfileViewControllerProtocol?
    
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private var oauth2TokenStorage = OAuth2TokenStorage.shared
}
extension ProfilePresenter: ProfilePresenterProtocol {
    
    func viewDidLoad() {
        checkAvatar()
        checkProfile()
    }
    
    func resetAccount() {
        resetToken()
        resetView()
        resetPhotos()
        cleanCookies()
        switchToSplashViewController()
    }
    
    func checkAvatar() {
        if let url = profileImageService.avatarURL {
            view?.updateAvatar(url: url)
        }
    }
    
    func checkProfile() {
        guard let profile = profileService.profile else {
            return
        }
        view?.loadProfile(profile)
    }
    func resetToken() {
        guard oauth2TokenStorage.removeToken() else {
            assertionFailure("Cannot remove token")
            return
        }
    }
    
    func resetView() {
        view?.loadProfile(nil)
    }
    
    func resetPhotos() {
        ImagesListService.shared.resetPhotos()
    }
    
    func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) { }
            }
        }
    }
    
    func switchToSplashViewController() {
        
        guard let window = UIApplication.shared.windows.first else {
            preconditionFailure("Invalid Configuration") }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
