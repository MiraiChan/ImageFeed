//
//  ProfileViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Almira Khafizova on 15.10.23.
//

import XCTest
@testable import ImageFeed

final class ProfileViewControllerTests: XCTestCase {

  let viewController = ProfileViewControllerSpy()
  let presenter = ProfilePresenter()

  override func setUpWithError() throws {
    viewController.presenter = presenter
      presenter.view = (viewController as any ProfileViewControllerProtocol)
  }

  func testPresenterCallsLoadProfile() {
    // given
    let testUser = "test"
    let testProfile = Profile(username: testUser, name: testUser, loginName: testUser, bio: testUser)

    // when
    viewController.loadProfile(testProfile)

    // then
    XCTAssertTrue(viewController.viewDidLoadProfile)
    
    XCTAssertEqual(viewController.profileUserNameLabel.text, testUser)
    XCTAssertEqual(viewController.profileLoginNameLabel.text, testUser)
    XCTAssertEqual(viewController.profileBioLabel.text, testUser)
  }

  func testPresenterCallsUpdateAvatar() {
    // given
    let testUrl = URL(string: "https://apple.com")!

    // when
    viewController.updateAvatar(url: testUrl)

    // then
    XCTAssertTrue(viewController.viewDidUpdateAvatar)
  }
}
