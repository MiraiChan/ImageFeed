//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 13.09.23.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
    static func setup() {
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.colorHUD = .clear
    }
}
