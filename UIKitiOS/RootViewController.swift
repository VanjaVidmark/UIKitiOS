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
        wireView()
        wireViewModel()
    }
}

// MARK: Private

private extension RootViewController {

    func wireView() {
        signupView.onEmailChanged = { [weak self] text in self?.signupViewModel.emailChanged(text) }
        signupView.onEmailEditingEnded = { [weak self] in self?.signupViewModel.emailEditingEnded() }

        signupView.onPasswordChanged = { [weak self] text in self?.signupViewModel.passwordChanged(text) }
        signupView.onPasswordEditingEnded = { [weak self] in self?.signupViewModel.passwordEditingEnded() }

        signupView.onConfirmationChanged = { [weak self] text in self?.signupViewModel.passwordConfirmationChanged(text) }
        signupView.onConfirmationEditingEnded = { [weak self] in self?.signupViewModel.confirmationEditingEnded() }

        signupView.onSignupTapped = { print("signup tapped") }
    }

    func wireViewModel() {
        signupViewModel.onFormValidityChanged = { [weak self] isValid in
            self?.signupView.setButtonEnabled(isValid)
        }
        signupViewModel.onEmailValidityChanged = { [weak self] isValid in
            self?.signupView.setEmailError(isValid ? nil : String(localized: .signupInvalidEmail))
        }
        signupViewModel.onPasswordValidityChanged = { [weak self] isValid in
            self?.signupView.setPasswordError(isValid ? nil : String(localized: .signupInvalidPassword))
        }
        signupViewModel.onConfirmationValidityChanged = { [weak self] isValid in
            self?.signupView.setConfirmationError(isValid ? nil : String(localized: .signupInvalidPassword))
        }
        signupViewModel.onConfirmationMismatch = { [weak self] in
            self?.signupView.setConfirmationError(String(localized: .signupNotMatchingPassword))
        }
    }
}
