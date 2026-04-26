//
//  AppCoordinator.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // Note: to simplify testing, instead of initializing it like this i can pass it
    // to the initializer. That way i can use a mock nav controller in tests.
    var navigationController = UINavigationController()
    
    func start() ->  UIViewController {
        let vc = SignupViewController(onSignupTapped: {
            [weak self] email in self?.showHome(email: email)
        })
        navigationController.setViewControllers([vc], animated: false)
        return navigationController
    }
}

// MARK: Helpers

private extension AppCoordinator {
    func showHome(email: Email) {
        navigationController.pushViewController(HomeViewController(email: email), animated: true)
    }
}
