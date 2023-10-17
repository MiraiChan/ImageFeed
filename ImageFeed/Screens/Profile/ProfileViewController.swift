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
    private var label1 = UILabel()
    private var label2 = UILabel()
    private var label3 = UILabel()
    private let imageView = UIImageView()
    private var logoutButton: UIButton!
    
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: AlertPresenting?
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
        imageView.image = profileImagePlaceholder
        imageView.tintColor = .gray
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func setupLabel() {
        label1.textColor = .ypWhite
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
        
        label2.textColor = .ypGray
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
        
        label3.textColor = .ypWhite
        let font3 = UIFont.systemFont(ofSize: 13, weight: .regular)
        label3.font = font3
        label3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label3)
        label3.leadingAnchor.constraint(equalTo: label1.leadingAnchor).isActive = true
        label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupButton() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward") ?? UIImage(),
            target: self,
            action: #selector(self.didTapButton)
        )
        logoutButton.tintColor = .ypRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
}
extension ProfileViewController: ProfileViewControllerProtocol {
    
    func loadProfile(_ profile: Profile?) {
        if let profile = profileService.profile {
            label1.text = profile.name
            label2.text = profile.loginName
            label3.text = profile.bio
        } else {
            label1.text = "Error. User's name not found."
            label2.text = "Error"
            label3.text = "Error"
            imageView.image = profileImagePlaceholder
        }
    }
    
    func updateAvatar(url: URL) {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "user_picture"),
                              options: [.processor(processor)])
    }
}
