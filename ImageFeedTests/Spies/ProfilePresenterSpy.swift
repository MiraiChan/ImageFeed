//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Almira Khafizova on 15.10.23.
//


import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var viewDidResetAccount = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func resetAccount() {
        viewDidResetAccount = true
    }
}
