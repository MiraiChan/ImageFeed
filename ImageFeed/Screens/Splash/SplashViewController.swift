//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 04.09.23.
//

import UIKit
import WebKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: AlertPresenterProtocol?
    private var wasChecked = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        splashScreenUISetup()
        UIBlockingProgressHUD.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        authStatusChecker()
    }
}

private extension SplashViewController {
    func authStatusChecker () {
        guard !wasChecked else { return }
        wasChecked = true
        if oauth2Service.isAuthenticated {
            UIBlockingProgressHUD.show()
            fetchProfile {
                [weak self] in
                UIBlockingProgressHUD.dismiss()
                self?.switchToTabBarController()
            }
        } else {
            switchToAuthViewController()
        }
    }

    func showLoginAlert(error: Error, cb: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertModel = AlertModel(
                title: "Что-то пошло не так (",
                message: "Не удалось войти в систему",
                buttonText: "Ok") {
                    self.wasChecked = false
                    guard OAuth2TokenStorage.shared.removeToken() else {
                        assertionFailure("Failed to remove token")
                        return
                    }
                    self.authStatusChecker()
                }
            self.alertPresenter?.showAlert(for: alertModel)
            cb?()
        }
    }
}

private extension SplashViewController {
    private func switchToAuthViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { preconditionFailure("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func splashScreenUISetup() {
        view.backgroundColor = .ypBackground
        
        let splashScreenImage = UIImage(named: "splash_screen_logo")
        let splashScreenImageView = UIImageView(image: splashScreenImage)
        splashScreenImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(splashScreenImageView)
        
        NSLayoutConstraint.activate([
            splashScreenImageView.heightAnchor.constraint(equalToConstant: 77),
            splashScreenImageView.widthAnchor.constraint(equalToConstant: 75),
            splashScreenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashScreenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
private extension SplashViewController {
    func fetchAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                self.fetchProfile(completion: {
                    UIBlockingProgressHUD.dismiss()
                })
            case .failure(let error):
                self.showLoginAlert(error: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func fetchProfile(completion: @escaping () -> Void) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                let userName = profile.username
                self.fetchProfileImage(userName: userName)
            case .failure(let error):
                self.showLoginAlert(error: error, cb: completion)
            }
            completion()
        }
    }
    
    func fetchProfileImage(userName: String) {
        
        profileImageService.fetchProfileImageURL(userName: userName) { [weak self] profileImageUrl in
            
            guard let self else { return }
            
            switch profileImageUrl {
            case .success:
                self.switchToTabBarController()
            case .failure(let error):
                self.showLoginAlert(error: error)
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) {
            [weak self] in
            guard let self else { return }
            self.fetchAuthToken(code)
        }
    }
}
