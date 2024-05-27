//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 15.08.23.


import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func loadProfile(_ profile: Profile?)
}

final class ProfileViewController: UIViewController {
    private var profileUserNameLabel = UILabel()
    private var profileLoginNameLabel = UILabel()
    private var profileBioLabel = UILabel()
    private let profileUserPhotoImage = UIImageView()
    private var logoutButton: UIButton!
    
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: AlertPresenterProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    var presenter: ProfilePresenterProtocol?
    let profileImagePlaceholder = UIImage(named: "user_picture")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        alertPresenter = AlertPresenter(viewController: self)
        presenter?.viewDidLoad()
        
        NotificationObserver()
        
        setupImageView()
        setupLabel()
        setupButton()
    }
}

private extension ProfileViewController {
    
    @objc func didTapButton() {
        showAlert()
    }
    
    @objc func updateAvatar(notification: Notification) {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo[Notification.userInfoImageURLKey] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        updateAvatar(url: url)
    }
    
    func NotificationObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] notification in
                guard let self else { return }
                self.updateAvatar(notification: notification)
            }
        )
    }
    
    func showAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertModel = AlertModel(
                title: "Пока, пока!",
                message: "Уверены, что хотите выйти?",
                buttonText: "Да",
                completion: { self.presenter?.resetAccount() },
                secondButtonText: "Нет",
                secondCompletion: { self.dismiss(animated: true) }
            )
            self.alertPresenter?.showAlert(for: alertModel)
        }
    }
    
    private func setupImageView() {
        profileUserPhotoImage.image = profileImagePlaceholder
        profileUserPhotoImage.tintColor = .gray
        
        profileUserPhotoImage.accessibilityIdentifier = "ProfilePhoto"
        
        profileUserPhotoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileUserPhotoImage)
        
        profileUserPhotoImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        profileUserPhotoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        profileUserPhotoImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileUserPhotoImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func setupLabel() {
        
        profileUserNameLabel.accessibilityIdentifier = "ProfileName"
        profileUserNameLabel.textColor = .ypWhite
        let font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 18 / font.pointSize
        let attributes: [NSAttributedString.Key : Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        profileUserNameLabel.attributedText = NSAttributedString(string: profileUserNameLabel.text ?? "", attributes: attributes)
        
        profileUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileUserNameLabel)
        profileUserNameLabel.leadingAnchor.constraint(equalTo: profileUserPhotoImage.leadingAnchor).isActive = true
        profileUserNameLabel.topAnchor.constraint(equalTo: profileUserPhotoImage.bottomAnchor, constant: 20).isActive = true
        
        profileLoginNameLabel.accessibilityIdentifier = "ProfileLogin"
        profileLoginNameLabel.textColor = .ypGray
        let font2 = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        let attributes2: [NSAttributedString.Key: Any] = [
            .font: font2,
            .paragraphStyle: paragraphStyle
        ]
        profileLoginNameLabel.attributedText = NSAttributedString(string: profileLoginNameLabel.text ?? "", attributes: attributes2)
        profileLoginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileLoginNameLabel)
        profileLoginNameLabel.leadingAnchor.constraint(equalTo: profileUserNameLabel.leadingAnchor).isActive = true
        profileLoginNameLabel.topAnchor.constraint(equalTo: profileUserNameLabel.bottomAnchor, constant: 20).isActive = true
        
        profileBioLabel.accessibilityIdentifier = "ProfileBio"
        profileBioLabel.textColor = .ypWhite
        let font3 = UIFont.systemFont(ofSize: 13, weight: .regular)
        profileBioLabel.font = font3
        profileBioLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileBioLabel)
        profileBioLabel.leadingAnchor.constraint(equalTo: profileUserNameLabel.leadingAnchor).isActive = true
        profileBioLabel.topAnchor.constraint(equalTo: profileLoginNameLabel.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupButton() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward") ?? UIImage(),
            target: self,
            action: #selector(self.didTapButton)
        )
        
        logoutButton.accessibilityIdentifier = "LogoutButton"
        
        logoutButton.tintColor = .ypRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: profileUserPhotoImage.centerYAnchor).isActive = true
    }
}
extension ProfileViewController: ProfileViewControllerProtocol {
    
    func loadProfile(_ profile: Profile?) {
        if let profile = profileService.profile {
            profileUserNameLabel.text = profile.name
            profileLoginNameLabel.text = profile.loginName
            profileBioLabel.text = profile.bio
        } else {
            profileUserNameLabel.text = "Error. User's name not found."
            profileLoginNameLabel.text = "Error"
            profileBioLabel.text = "Error"
            profileUserPhotoImage.image = profileImagePlaceholder
        }
    }
    
    func updateAvatar(url: URL) {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileUserPhotoImage.kf.indicatorType = .activity
        profileUserPhotoImage.kf.setImage(with: url,
                                          placeholder: UIImage(named: "user_picture"),
                                          options: [.processor(processor)])
    }
}
