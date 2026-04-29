//
//  SceneDelegate.swift
//  UIKitiOS
//
//  Created by Alexander Cyon on 2026-04-23.
//

import UIKit

final class AppCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

extension AppCoordinator {
    
    func start() {
        log.warning("Incorrectly always navigating to signup")
        toSignup()
    }
    
}

extension AppCoordinator {
    
    private func makeSignupVC() -> SignupVC {
        SignupVC()
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

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        let appCoordinator = AppCoordinator(navigationController: navigationController)
        defer {
            appCoordinator.start()
        }
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
		self.window = window
	}

}

