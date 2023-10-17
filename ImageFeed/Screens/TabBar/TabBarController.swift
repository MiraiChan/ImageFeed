//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 20.09.23.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabBarVC()
    }
    
    func setupTabBar() {
        tabBar.barStyle = .black
        tabBar.tintColor = .ypWhite
        tabBar.backgroundColor = .ypBlack
    }
    
    func setupTabBarVC() {
        view.backgroundColor = .ypBackground
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        guard let imagesListViewController = imagesListViewController as? ImagesListViewController else { return }
        
        let profilePresenter = ProfilePresenter()
        let profileViewController = ProfileViewController()
        profilePresenter.view = profileViewController
        profileViewController.presenter = profilePresenter
        
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )

        
        self.viewControllers = [imagesListViewController, profileViewController]
        selectedIndex = 0
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        selectedViewController = viewController
    }
}

