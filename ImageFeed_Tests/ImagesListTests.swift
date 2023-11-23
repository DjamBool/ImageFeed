//
//  ImagesListTests.swift
//  ImageFeed_Tests
//
//  Created by Игорь Мунгалов on 23.11.2023.
//

@testable import ImageFeed
import XCTest
import UIKit
import Foundation

final class ImagesListTests: XCTestCase {

    func testViewDidLoad() {
        //given
        let presenter = ImagesListPresenterSpy()
        let viewController = ImagesListViewController()
        presenter.view = viewController
        viewController.presenter = presenter
        //when
        _ = viewController.view
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    func testUpdateTableViewAnimatedCalls() {
        //given
        let presenter = ImagesListPresenterSpy()
        let viewController = ImagesListViewControllerSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        //when
        viewController.updateTableViewAnimated()
        //then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalls)
    }
    
    func testConfigTableViewCalls() {
        //given
        let presenter = ImagesListPresenterSpy()
        let viewController = ImagesListViewControllerSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        //when
        viewController.configTableView()
        //then
        XCTAssertTrue(viewController.configTableViewCalls)
    }
}


//MARK: - Дублеры

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    var tableView: UITableView!
    
    var configTableViewCalls: Bool = false
    var viewDidLoadCalls: Bool = false
    var viewDidDisappearCalls: Bool = false
    var updateTableViewAnimatedCalls: Bool = false
    
    func configTableView() {
        configTableViewCalls = true
    }
    
    func viewDidLoad() {
        viewDidLoadCalls = true
    }
    
    func viewDidDisappear(_ animated: Bool) {
        viewDidDisappearCalls = true
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalls = true
    }
}

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var photosCount: Int = 0
    var viewDidLoadCalled: Bool = false
    var viewDidDisappearCalled: Bool = false
    var updateTableViewAnimatedCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func viewDidDisappear() {
        viewDidDisappearCalled = true
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
}
