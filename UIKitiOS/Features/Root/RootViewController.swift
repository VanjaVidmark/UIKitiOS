//
//  RootViewController.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

import UIKit

final class RootViewController: UINavigationController {
    
    private lazy var signupViewController = SignupViewController(onSignupTapped: onSignupTapped)

}

// MARK: Override

extension RootViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([signupViewController], animated: false)
    }
    
}


// MARK: Helper

extension RootViewController {
    
    private func onSignupTapped(email : Email) -> Void {
        pushViewController(
            HomeViewController(email: email),
            animated: true
        )
    }
    
    
}
