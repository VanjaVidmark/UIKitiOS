//
//  AppCoordinator.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

import Foundation
 
final class AppCoordinator<Screen: AppScreenProtocol>{
    
    private unowned let navigationController: any NavigationProtocol<Screen>
    private unowned let userStorage: any SecureStorageOfUser
    
    init(
        navigationController: any NavigationProtocol<Screen>,
        userStorage: any SecureStorageOfUser,
    ) {
        self.navigationController = navigationController
        self.userStorage = userStorage
    }
    
}

extension AppCoordinator {
    
    func start() {
        if let user = try? userStorage.loadUser() {
            toHome(loggedInUser: user, animated: false)
        } else {
            toSignup(animated: false)
        }
    }
    
}

extension AppCoordinator: SignupNavigationDelegate {
    func userSignedUp(jwt: JWT, user: User) {
        toHome(loggedInUser: user, animated: true)
    }
}

extension AppCoordinator: HomeNavigationDelegate {
    func userSignedOut() {
        toSignup(animated: true)
    }
}

// MARK: Private

extension AppCoordinator {
    
    private func makeSignupScreen() -> Screen {
        Screen.makeSignup(userStorage: userStorage, navigationDelegate: self)
    }
    
    private func toSignup(animated: Bool = false) {
        let screen = makeSignupScreen()
        navigationController.setScreens([screen], animated: animated)
    }
    
    private func makeHomeScreen(loggedInUser: User) -> Screen {
        Screen.makeHome(loggedInUser: loggedInUser, userStorage: userStorage, navigationDelegate: self)
    }
    
    private func toHome(loggedInUser: User, animated: Bool = false) {
        let screen = makeHomeScreen(loggedInUser: loggedInUser)
        navigationController.setScreens([screen], animated: animated)
    }
}

