//
//  AppCoordinatorTests.swift
//  UIKitiOS
//

import XCTest
@testable import UIKitiOS

final class AppCoordinatorTests: XCTestCase {
    
    var defaultNavigationController: any NavigationProtocol<MockAppScreen> = MockNavigationController()
    var defaultUserStorage: any SecureStorageOfUser = MockUserStorage(initialUser: nil)
    
    override func setUp() {
        self.defaultNavigationController = MockNavigationController()
        self.defaultUserStorage = MockUserStorage(initialUser: nil)
    }

    // MARK: start

    func test_start_withStoredUser_navigatesToHome() async /* needed to bypass xcode26.1 bug forums.swift.org/t/84034 */ {
        // Arrange
        let navigation = MockNavigationController()
        let loggedInUser = User.example
        let storage = MockUserStorage(initialUser: loggedInUser)
        let sut = sut(navigationController: navigation, userStorage: storage)
        
        // Act
        sut.start()
        
        // Assert
        XCTAssertEqual(navigation.screens, [.init(screen: .home(loggedInUser: loggedInUser), animated: false)])
    }
    
    func test_start_withoutStoredUser_navigatesToSignup() async /* needed to bypass xcode26.1 bug forums.swift.org/t/84034 */ {
        // Arrange
        let navigation = MockNavigationController()
        let sut = sut(navigationController: navigation)
        
        // Act
        sut.start()
        
        // Assert
        XCTAssertEqual(navigation.screens, [.init(screen: .signUp, animated: false)])
    }
    
    // MARK: userSignedUp
    
    func test_userSignedUp_navigatesToHome() {
        // Arrange
        let navigation = MockNavigationController()
        let sut = sut(navigationController: navigation)
        let loggedInUser = User.example
        sut.start()
        XCTAssertEqual(navigation.screens.map(\.screen), [.signUp], "precondition: navigation should start on signUp screen")
        
        // Act
        sut.userSignedUp(jwt: "test-jwt", user: loggedInUser)
        
        // Assert
        XCTAssertEqual(navigation.screens, [.init(screen: .home(loggedInUser: loggedInUser), animated: true)])
    }
    
    // MARK: userSignedOut
    
    func test_userSignedOut_navigatesToSignup() {
        // Arrange
        let navigation = MockNavigationController()
        let userStorage = MockUserStorage.withUser()
        let sut = sut(navigationController: navigation, userStorage: userStorage)
        sut.start()
        XCTAssertEqual(navigation.screens.map(\.screen), [.home(loggedInUser: userStorage.user!)], "precondition: navigation should start on home screen since there is a user stored")
        
        // Act
        sut.userSignedOut()
        
        // Assert
        XCTAssertEqual(navigation.screens, [.init(screen: .signUp, animated: true)])
    }
    
}

// MARK: Helpers

extension AppCoordinatorTests {
    
    private func sut(
        navigationController: (any NavigationProtocol<MockAppScreen>)? = nil,
        userStorage: (any SecureStorageOfUser)? = nil
    ) -> AppCoordinator<MockAppScreen> {
        AppCoordinator(
            navigationController: navigationController ?? self.defaultNavigationController,
            userStorage: userStorage ?? self.defaultUserStorage
        )
    }
}
