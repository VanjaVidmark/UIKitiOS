//
//  AppScreenProtocol.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-30.
//

import UIKit


protocol AppScreenProtocol {
    
    static func makeHome(
        loggedInUser: User,
        userStorage: any SecureStorageOfUser,
        navigationDelegate: any HomeNavigationDelegate,
    ) -> Self
    
    static func makeSignup(
        userStorage: any SecureStorageOfUser,
        navigationDelegate: any SignupNavigationDelegate,
    ) -> Self
}

// MARK: AppScreen

enum AppScreen {
    case home(HomeVC)
    case signup(SignupVC)
}

extension AppScreen: AppScreenProtocol {
    
    static func makeHome(
        loggedInUser: User,
        userStorage: any SecureStorageOfUser,
        navigationDelegate: any HomeNavigationDelegate
    ) -> Self {
        Self.home(
            HomeVC(
                loggedInUser: loggedInUser,
                userStorage: userStorage,
                navigationDelegate: navigationDelegate,
            )
        )
    }
    
    static func makeSignup(
        userStorage: any SecureStorageOfUser,
        navigationDelegate: any SignupNavigationDelegate
    ) -> Self {
        Self.signup(
            SignupVC(
                navigationDelegate: navigationDelegate,
                userStorage: userStorage,
            )
        )
    }
}

extension AppScreen {
    var vc: UIViewController {
        switch self {
            case .home(let vc): return vc
            case .signup(let vc): return vc
        }
    }
}
