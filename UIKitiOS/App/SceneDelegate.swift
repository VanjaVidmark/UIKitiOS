//
//  SceneDelegate.swift
//  UIKitiOS
//
//  Created by Alexander Cyon on 2026-04-23.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    typealias Coordinator = AppCoordinator<AppScreen>
	var window: UIWindow?
    var appCoordinator: Coordinator?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        let appCoordinator = Coordinator(
            navigationController: navigationController,
            userStorage: Insecure︕！StorageOfUser.shared,
        )
        self.appCoordinator = appCoordinator
        defer {
            appCoordinator.start()
        }
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
		self.window = window
	}

}

