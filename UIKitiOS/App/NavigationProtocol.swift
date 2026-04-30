//
//  NavigationProtocol.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-30.
//

import UIKit

protocol NavigationProtocol<Screen>: AnyObject {
    associatedtype Screen
    func setScreens(_ screens: [Screen], animated: Bool)
}

extension UINavigationController: NavigationProtocol {
    typealias Screen = AppScreen
    
    func setScreens(_ screens: [Screen], animated: Bool) {
        setViewControllers(screens.map(\.vc), animated: animated)
    }
}
