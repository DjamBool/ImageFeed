//
//  ProfileTests.swift
//  ImageFeed_Tests
//
//  Created by Игорь Мунгалов on 22.11.2023.
//
@testable import ImageFeed
import XCTest
import Foundation
import UIKit

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        _ = viewController.view
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testExitAlertShows() {
        // given
        let presenter = ProfileViewPresenterSpy()
        let viewController = ProfileViewControllerSpy(presenter: presenter)
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        viewController.showExitConfirmation()
        //then
        XCTAssertTrue(viewController.alertShowed)
    }
    
    func testUpdateProfileDetailsCalled() {
        // given
        let presenter = ProfileViewPresenterSpy()
        let viewController = ProfileViewControllerSpy(presenter: presenter)
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        viewController.updateProfileDetails()
        //then
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var updateAvatarCalled: Bool = false
    var showExitConfirmationCalled = false
    var updateProfileDetailsCalled: Bool = false
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func showExitConfirmation() -> UIAlertController {
        UIAlertController()
    }
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        updateProfileDetailsCalled = true
    }
    
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfileViewPresenterProtocol
    init(presenter: ImageFeed.ProfileViewPresenterProtocol) {
        self.presenter = presenter
    }
    var updateProfileDetailsCalled: Bool = false
    var profileImageView = UIImageView()
    var nameLabel = UILabel()
    var loginNameLabel = UILabel()
    var descriptionLabel = UILabel()
    var alertShowed: Bool = false
    var isLogout: Bool = false
    var isClened: Bool = false
    
    func logout() {
        isLogout = true
    }
    func showExitConfirmation() {
        alertShowed = true
    }
    
    func clean() {
        isClened = true
    }
    func updateProfileDetails() {
        updateProfileDetailsCalled = true
    }
    
}
