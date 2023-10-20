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
    private let app = XCUIApplication() // переменная приложения
    
    enum authMockData {
        static let email = "User's email"
        static let pwd = "User's password"
        static let userName = "Name Surname"
        static let login = "Unsplash login (starting with @...)"
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        sleep(3)
        // Нажать кнопку авторизации
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        app.buttons["Authenticate"].tap()
        
        //найти на экране WebView и подождать
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        // найти поле для ввода логина и подождать
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        // нажать кнопку логина
        loginTextField.tap()
        //ввеcти текст в поле ввода
        loginTextField.typeText(authMockData.email)
        //скрыть клавиатуру после ввода текста
        webView.press(forDuration: 0.1, thenDragTo: webView)
        
        //повторяем аналогично с паролем
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(authMockData.pwd)
        webView.tap()
        sleep(3)
        
        //логинимся
        XCTAssertTrue(webView.buttons["Login"].waitForExistence(timeout: 3))
        webView.buttons["Login"].tap()
        
        
        // Подождать, пока открывается экран ленты
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // Подождать, пока открывается и загружается экран ленты
        
        let tableQuery = app.tables
        
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        // Сделать жест «смахивания» вверх по экрану для его скролла
        cell.swipeDown()
        sleep(2)
        
        let cellToLike = tableQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        XCTAssertTrue(cell.buttons["LikeButton"].waitForExistence(timeout: 1))
        // Поставить лайк в ячейке верхней картинки
        cellToLike.buttons["LikeButton"].tap()
        sleep(3)
        // Отменить лайк в ячейке верхней картинки
        cellToLike.buttons["LikeButton"].tap()
        sleep(3)
        // Нажать на верхнюю ячейку
        cellToLike.tap()
        // Подождать, пока картинка открывается на весь экран
        let image = app.scrollViews.images.element(boundBy: 0)
        // Увеличить картинку
        image.pinch(withScale: 3, velocity: 1)
        // Уменьшить картинку
        image.pinch(withScale: 0.5, velocity: -1)
        // Вернуться на экран ленты
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
