//
//  SignupViewModel.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

import Combine

final class SignupViewModel {
    private var email: String
    private var password: String
    private var passwordConfirmation: String

    private let emailValiditySubject = PassthroughSubject<Bool, Never>()
    private let passwordValiditySubject = PassthroughSubject<Bool, Never>()
    private let confirmationValiditySubject = PassthroughSubject<Bool, Never>()
    
    private let onFormValidityChangedSubject = PassthroughSubject<Bool, Never>()
    
    private let onConfirmationMismatchSubject = PassthroughSubject<Void, Never>()
    
    private let onEmailChangedPublisher: any Publisher<String, Never>
    private let onPasswordChangedPublisher: any Publisher<String, Never>
    private let onConfirmationChangedPublisher: any Publisher<String, Never>
    
    init(
        email: String = "",
        password: String = "",
        passwordConfirmation: String = "",
        onEmailChangedPublisher: any Publisher<String, Never>,
        onPasswordChangedPublisher: any Publisher<String, Never>,
        onConfirmationChangedPublisher: any Publisher<String, Never>
    ) {
        self.onEmailChangedPublisher = onEmailChangedPublisher
        self.onPasswordChangedPublisher = onPasswordChangedPublisher
        self.onConfirmationChangedPublisher = onConfirmationChangedPublisher
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }

}

// MARK: - Internal

extension SignupViewModel {
    var emailValidityPublisher: AnyPublisher<Bool, Never> {
        emailValiditySubject.eraseToAnyPublisher()
    }
    var passwordValidityPublisher: AnyPublisher<Bool, Never> {
        passwordValiditySubject.eraseToAnyPublisher()
    }
    var confirmationValidityPublisher: AnyPublisher<Bool, Never> {
        confirmationValiditySubject.eraseToAnyPublisher()
    }
    
    /*
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
     */
}

// MARK: Private

extension SignupViewModel {
    
    private var isEmailValid: Bool { (try? Email(raw: email)) != nil }
    private var isPasswordValid: Bool { (try? Password(raw: password)) != nil }
    private var isConfirmationValid: Bool { (try? Password(raw: passwordConfirmation)) != nil }
    private var passwordsMatch: Bool { password == passwordConfirmation }
    
    private var isFormValid: Bool {
        isEmailValid && isPasswordValid && isConfirmationValid && passwordsMatch
    }
    
}
