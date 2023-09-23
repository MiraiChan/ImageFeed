//
//  RootNavigationController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 23.09.23.
//

import UIKit

final class RootNavigationController: UINavigationController {
  override var childForStatusBarStyle: UIViewController? {
    return visibleViewController
  }
}
