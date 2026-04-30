//
//  AppCoordinatorTests.swift
//  UIKitiOS
//

import XCTest
import UIKit
@testable import UIKitiOS

final class AppCoordinatorTests: XCTestCase {

    // MARK: start

    func test_start_withStoredUser_navigatesToHome() async /* needed to bypass xcode26.1 bug forums.swift.org/t/84034 */ {
        let navigation = UINavigationController()
        let storage = MockUserStorageWithUser()
        let sut = AppCoordinator(navigationController: navigation, userStorage: storage)

        sut.start()
        XCTAssertTrue(navigation.topViewController is HomeVC)
    }

    func test_start_withNoStoredUser_navigatesToSignup() async /* needed to bypass xcode26.1 bug forums.swift.org/t/84034 */ {
        let navigation = UINavigationController()
        let storage = MockEmptyUserStorage()
        let sut = AppCoordinator(navigationController: navigation, userStorage: storage)

        sut.start()

        XCTAssertTrue(navigation.viewControllers.first is SignupVC)
    }
}
