//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Almira Khafizova on 27.07.23.
//

import XCTest
import UIKit
@testable import ImageFeed

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    enum authMockData {
        static let email = "User's email"
        static let pwd = "User's password"
        static let userName = "Name Surname"
        static let login = "Unsplash login (starting with @...)"
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        sleep(3)
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(authMockData.email)
        webView.press(forDuration: 0.1, thenDragTo: webView)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(authMockData.pwd)
        webView.tap()
        sleep(3)
        
        XCTAssertTrue(webView.buttons["Login"].waitForExistence(timeout: 3))
        webView.buttons["Login"].tap()
        
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeDown()
        sleep(2)
        
        let cellToLike = tableQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        XCTAssertTrue(cell.buttons["LikeButton"].waitForExistence(timeout: 1))
        cellToLike.buttons["LikeButton"].tap()
        sleep(3)
        cellToLike.buttons["LikeButton"].tap()
        sleep(3)
        
        cellToLike.tap()
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        XCTAssertTrue(app.buttons["BackButton"].waitForExistence(timeout: 5))
        app.buttons["BackButton"].tap()
    }
    
    func testProfile() throws {
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.buttons["LogoutButton"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[authMockData.userName].exists)
        XCTAssertTrue(app.staticTexts[authMockData.login].exists)
        
        app.buttons["LogoutButton"].tap()
        
        XCTAssertTrue(app.alerts["Alert"].waitForExistence(timeout: 5))
        app.alerts["Alert"].scrollViews.otherElements.buttons["Да"].tap()
        
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
    }
}
