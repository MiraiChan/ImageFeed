//
//  ProfilePresenter.swift
//  ImageFeedTests
//
//  Created by Almira Khafizova on 14.10.23.
//

import Foundation
import WebKit
import Kingfisher


public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func resetAccount()
}

final class ProfilePresenter {
    weak var view: ProfileViewControllerProtocol?
    
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
    
    private func checkAvatar() {
        if let url = profileImageService.avatarURL {
            view?.updateAvatar(url: url)
        }
    }
    
    private func checkProfile() {
        guard let profile = profileService.profile else {
            return
        }
        view?.loadProfile(profile)
    }
    private func resetToken() {
        guard oauth2TokenStorage.removeToken() else {
            assertionFailure("Failed remove token")
            return
        }
    }
    
    private func resetView() {
        view?.loadProfile(nil)
    }
    
    private func resetPhotos() {
        ImagesListService.shared.resetPhotos()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) { }
            }
        }
    }
    
    private func switchToSplashViewController() {
        
        guard let window = UIApplication.shared.windows.first else {
            preconditionFailure("Invalid Configuration") }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
