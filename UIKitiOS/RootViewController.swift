//
//  RootViewController.swift
//  UIKitiOS
//
//  Created by Alexander Cyon on 2026-04-23.
//

import UIKit

final class RootViewController: UIViewController {

    private let signupViewModel = SignupViewModel()
    private let signupView = SignupView()

}

// MARK: Override

extension RootViewController {

    override func loadView() {
        view = signupView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Maps all view callbacks into the correct VM method
        signupView.onEmailChanged = { [weak self] text in self?.signupViewModel.emailChanged(text) }
        signupView.onPasswordChanged = { [weak self] text in self?.signupViewModel.passwordChanged(text) }
        signupView.onConfirmationChanged = { [weak self] text in self?.signupViewModel.passwordConfirmationChanged(text) }
        signupView.onSignupTapped = { print("signup tapped") }
        
        // Enable button
        signupViewModel.onFormValidityChanged = { [weak self] isValid in
            self?.signupView.setButtonEnabled(isValid)
        }
    }
}
