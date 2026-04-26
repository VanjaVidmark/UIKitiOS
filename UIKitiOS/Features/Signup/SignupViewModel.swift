//
//  SignupViewModel.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

final class SignupViewModel {
    private var email = ""
    private var password = ""
    private var passwordConfirmation = ""

    var onFormValidityChanged: ((Bool) -> Void)?
    var onEmailValidityChanged: ((Bool) -> Void)?
    var onPasswordValidityChanged: ((Bool) -> Void)?
    var onConfirmationValidityChanged: ((Bool) -> Void)?
    var onConfirmationMismatch: (() -> Void)?

    private var isEmailValid: Bool { (try? Email(raw: email)) != nil }
    private var isPasswordValid: Bool { (try? Password(raw: password)) != nil }
    private var isConfirmationValid: Bool { (try? Password(raw: passwordConfirmation)) != nil }
    private var passwordsMatch: Bool { password == passwordConfirmation }

    private var isFormValid: Bool {
        isEmailValid && isPasswordValid && isConfirmationValid && passwordsMatch
    }

    func emailChanged(_ text: String) {
        email = text
        if isEmailValid { onEmailValidityChanged?(true) }
        onFormValidityChanged?(isFormValid)
    }

    func passwordChanged(_ text: String) {
        password = text
        if isPasswordValid { onPasswordValidityChanged?(true) }
        onFormValidityChanged?(isFormValid)
    }

    func passwordConfirmationChanged(_ text: String) {
        passwordConfirmation = text
        if isConfirmationValid { onConfirmationValidityChanged?(true) }
        onFormValidityChanged?(isFormValid)
    }

    func emailEditingEnded() {
        onEmailValidityChanged?(isEmailValid)
    }

    func passwordEditingEnded() {
        onPasswordValidityChanged?(isPasswordValid)
    }

    func confirmationEditingEnded() {
        guard isConfirmationValid else {
            onConfirmationValidityChanged?(false)
            return
        }
        if !passwordsMatch {
            onConfirmationMismatch?()
        } else {
            onConfirmationValidityChanged?(true)
        }
    }
}
