//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Игорь Мунгалов on 23.11.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let testName = "Igor Igor"
    private let testUsername = "@igor_m_2023"
    private let testEmail = "moongaloff@me.com"
    private let password = "YaPracticum"
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(testEmail)
        app.toolbars.buttons["Done"].tap()
        // webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 3))
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        if app.keyboards.element(boundBy: 0).exists {
            app.toolbars.buttons["Done"].tap()
        }
        sleep(3)
        
        XCTAssertTrue(webView.buttons["Login"].waitForExistence(timeout: 5))
        
        webView.swipeUp()
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)

        cellToLike.buttons["likeButton"].tap()
        sleep(2)
        cellToLike.buttons["likeButton"].tap()

        sleep(2)
        cellToLike.tap()
        sleep(2)
        
        //        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        //
        //        XCTAssertTrue(cellToLike.waitForExistence(timeout: 3))
        //        XCTAssertTrue(cellToLike.buttons["likeButton"].waitForExistence(timeout: 1))
        //        cellToLike.buttons["likeButton"].tap()
        //        sleep(3)
        //        cellToLike.buttons["likeButton"].tap()
        //
        //        sleep(3)
        //        cellToLike.tap()
        //        sleep(2)
        
//        let cellToLike = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
//        
//        let likeButton = cellToLike.descendants(matching: .button).element(boundBy: 0)
//        
//        likeButton.tap()
//        
//        sleep(2)
//        
//        likeButton.tap()
//        
//        sleep(2)
//        
//        cellToLike.tap()
//        
//        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1) // zoom in
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["\(testName)"].exists)
        XCTAssertTrue(app.staticTexts["\(testUsername)"].exists)
        
        app.buttons["logoutButton"].tap()
        app.alerts["goodbye"].scrollViews.otherElements.buttons["Yes"].tap()
        sleep(3)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
