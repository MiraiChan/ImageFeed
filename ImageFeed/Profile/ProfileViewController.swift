//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 15.08.23.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    private var label1: UILabel!
    private var label2 = UILabel()
    private var label3 = UILabel()
    private let imageView = UIImageView()
    
    private let profileService = ProfileService.shared
    
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
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() {
        // Решение 1
        label1?.removeFromSuperview()
        label1 = nil
        
        // Решение 2
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
}
