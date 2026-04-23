//
//  AppDelegate.swift
//  UIKitiOS
//
//  Created by Alexander Cyon on 2026-04-23.
//

import UIKit
@_exported import OSLog

let log = Logger(subsystem: "com.example.UIKitiOS", category: "App")

@main
class AppDelegate: UIResponder {}

// MARK: UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions
	) -> UISceneConfiguration {
		UISceneConfiguration(
			name: "Default Configuration",
			sessionRole: connectingSceneSession.role
		)
	}
}

