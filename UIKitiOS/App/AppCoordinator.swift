//
//  AppCoordinator.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

import Foundation
import UIKit

final class AppCoordinator {
    
    private let navigationController: UINavigationController
    private unowned let userStorage: any SecureStorageOfUser
    
    init(
        navigationController: UINavigationController,
        userStorage: any SecureStorageOfUser,
    ) {
        self.navigationController = navigationController
        self.userStorage = userStorage
    }
    
}

extension AppCoordinator {
    
    func start() {
        log.warning("Incorrectly always navigating to signup")
        if let user = try? userStorage.loadUser() {
            toHome(loggedInUser: user)
        } else {
            toSignup()
        }
    }
    
}

extension AppCoordinator: SignupNavigationDelegate {
    func userSignedUp(jwt: JWT, user: User) {
        toHome(loggedInUser: user)
    }
}

// MARK: Private

extension AppCoordinator {
    
    private func makeSignupVC() -> SignupVC {
        SignupVC(navigationDelegate: self, userStorage: userStorage)
    }
    
    private func toSignup() {
        let vc = makeSignupVC()
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func makeHomeVC(loggedInUser: User) -> HomeVC {
        HomeVC(loggedInUser: loggedInUser)
    }
    
    private func toHome(loggedInUser: User, animated: Bool = true) {
        let vc = makeHomeVC(loggedInUser: loggedInUser)
        navigationController.setViewControllers([vc], animated: animated)
    }
}
