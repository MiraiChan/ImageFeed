//
//  ProfilePresenterTests.swift
//  ImageFeedTests
//
//  Created by Almira Khafizova on 15.10.23.
//

import XCTest
@testable import ImageFeed

final class ProfilePresenterTests: XCTestCase {

  let viewController = ProfileViewController()
  let presenter = ProfilePresenterSpy()

  override func setUpWithError() throws {
    // given
      viewController.presenter = presenter as ProfilePresenterProtocol
    presenter.view = viewController
  }

  func testViewControllerCallViewDidLoad() {
    // when
    _ = viewController.view

    // then
    XCTAssertTrue(presenter.viewDidLoadCalled)
  }

  func testViewControllerCallResetAccount() {
    // when
    _ = viewController.view
    presenter.resetAccount()

    // then
    XCTAssertTrue(presenter.viewDidResetAccount)
  }
}
