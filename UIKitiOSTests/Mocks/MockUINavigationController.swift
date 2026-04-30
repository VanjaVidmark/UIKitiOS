//
//  MockUINavigationController.swift
//  UIKitiOSTests
//
//  Created by Vanja Vidmark on 2026-04-30.
//

@testable import UIKitiOS

final class MockNavigationController {
    struct ScreenWithAnimation: Equatable {
        let screen: Screen
        let animated: Bool
    }
    
    var screens: [ScreenWithAnimation] = []
}

extension MockNavigationController: NavigationProtocol {
    typealias Screen = MockAppScreen
    
    func setScreens(_ screens: [Screen], animated: Bool) {
        self.screens = screens
            .map {($0, animated)}
            .map(ScreenWithAnimation.init(screen:animated:))
    }
}

enum MockAppScreen {
    case signUp
    case home(loggedInUser: User)
}

extension MockAppScreen: Equatable {}

extension MockAppScreen: AppScreenProtocol {
    static func makeHome(
        loggedInUser: User,
        userStorage: any SecureStorageOfUser,
        navigationDelegate: any HomeNavigationDelegate
    ) -> MockAppScreen {
        .home(loggedInUser: loggedInUser)
    }
    
    static func makeSignup(
        userStorage: any SecureStorageOfUser,
        navigationDelegate: any SignupNavigationDelegate
    ) -> MockAppScreen {
        .signUp
    }
}
