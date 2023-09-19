//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 15.08.23.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var label1: UILabel!
    private var label2 = UILabel()
    private var label3 = UILabel()
    private let imageView = UIImageView()
    private var logoutButton: UIButton!
    
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        setupLabel()
        setupButton()
        
        updateProfileDetails(profile: profileService.profile)
        
    }
    
    private func updateProfileDetails(profile: Profile?) {
        if let profile = profile {
            label1.text = profile.name
            label2.text = profile.loginName
            label3.text = profile.bio
        } else {
            label1.text = "Error"
            label2.text = "Error"
            label3.text = "Error"
        }
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        )
        
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
            let imageURL = URL(string: profileImageURL)
        else { return }
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()

        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageURL,
                                     placeholder: UIImage(named: "user_picture"),
                                     options: [.processor(processor)])
    }
    
    private func setupImageView() {
        let profileImage = UIImage(named: "profileImage")
        imageView.image = profileImage
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func setupLabel() {
        let label1 = UILabel()
        label1.text = "Екатерина Новикова"
        label1.textColor = UIColor(named: "YP White")
        let font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 18 / font.pointSize
        let attributes: [NSAttributedString.Key : Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        label1.attributedText = NSAttributedString(string: label1.text ?? "", attributes: attributes)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label1)
        label1.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label1.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        self.label1 = label1
        
        let label2 = UILabel()
        label2.text = "@ekaterina_nov"
        label2.textColor = UIColor(named: "YP Gray")
        let font2 = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        let attributes2: [NSAttributedString.Key: Any] = [
            .font: font2,
            .paragraphStyle: paragraphStyle
        ]
        label2.attributedText = NSAttributedString(string: label2.text ?? "", attributes: attributes2)
        label2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label2)
        label2.leadingAnchor.constraint(equalTo: label1.leadingAnchor).isActive = true
        label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 20).isActive = true
        self.label2 = label2
        
        let label3 = UILabel()
        label3.text = "Hello, world!"
        label3.textColor = UIColor(named: "YP White")
        let font3 = UIFont.systemFont(ofSize: 13, weight: .regular)
        label3.font = font3
        label3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label3)
        label3.leadingAnchor.constraint(equalTo: label1.leadingAnchor).isActive = true
        label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 20).isActive = true
        self.label3 = label3
    }
    
    private func setupButton() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        logoutButton.tintColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() {
        imageView.image = UIImage(named: "user_picture")
        label1.text = "User's name"
        oauth2TokenStorage.token = nil
        logoutButton.isEnabled = false
    }
}
