//
//  SignupViewModel.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

import Foundation
import Combine

struct User: CustomStringConvertible {
    let email: Email
    let password: Password
}

extension User {
    var description: String
    {
        "email: \(email)"
    }
}

final class SignupViewModel {

    private let emailSubject = PassthroughSubject<Email?, Never>()
    private let passwordSubject = PassthroughSubject<Password?, Never>()
    private let confirmationSubject = PassthroughSubject<Password?, Never>()
    
    private let onFormValidityChangedSubject = PassthroughSubject<Bool, Never>()
    
    private let onConfirmationMismatchSubject = PassthroughSubject<Void, Never>()
    
    private let onEmailChangedPublisher: AnyPublisher<String, Never>
    private let onPasswordChangedPublisher: AnyPublisher<String, Never>
    private let onConfirmationChangedPublisher: AnyPublisher<String, Never>
    private let onButtonTap: AnyPublisher<Void, Never>
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        onEmailChangedPublisher: any Publisher<String, Never>,
        onPasswordChangedPublisher: any Publisher<String, Never>,
        onConfirmationChangedPublisher: any Publisher<String, Never>,
        onButtonTap: any Publisher<Void, Never>
    ) {
        self.onEmailChangedPublisher = onEmailChangedPublisher.eraseToAnyPublisher()
        self.onPasswordChangedPublisher = onPasswordChangedPublisher.eraseToAnyPublisher()
        self.onConfirmationChangedPublisher = onConfirmationChangedPublisher.eraseToAnyPublisher()
        self.onButtonTap = onButtonTap.eraseToAnyPublisher()
        self.onButtonTap
            .combineLatest(validUserPublisher.filterOutNil())
            .map { _, user in user }
            .sink(receiveValue: {user in print(user)})
            .store(in: &cancellables)
        self.onEmailChangedPublisher
            .map { rawEmail in try? Email(raw: rawEmail) }
            .sink(receiveValue: { [weak emailSubject] email in emailSubject?.send(email)})
            .store(in: &cancellables)
        self.onPasswordChangedPublisher
            .map { rawPassword in try? Password(raw: rawPassword)}
            .sink(receiveValue: { [weak passwordSubject] password in passwordSubject?.send(password)})
            .store(in: &cancellables)
        self.onConfirmationChangedPublisher
            .map { rawConfirmation in try? Password(raw: rawConfirmation)}
            .sink(receiveValue: { [weak confirmationSubject] confirmation in confirmationSubject?.send(confirmation)})
            .store(in: &cancellables)
    }

}

public protocol OptionalProtocol {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalProtocol {
    public var value: Wrapped? {
        self
    }
}

extension Publisher where Output: OptionalProtocol {
    public func filterOutNil() -> AnyPublisher<Output.Wrapped, Failure> {
        compactMap { maybeOutput in
            guard let unwrapped = maybeOutput.value else {
                return nil
            }
            return unwrapped
        }.eraseToAnyPublisher()
    }
}
// MARK: - Internal

extension SignupViewModel {
    private var emailValuePublisher: AnyPublisher<Email?, Never> {
        emailSubject.eraseToAnyPublisher()
    }
    var passwordPublisher: AnyPublisher<Password?, Never> {
        passwordSubject.eraseToAnyPublisher()
    }
    var confirmationPublisher: AnyPublisher<Password?, Never> {
        confirmationSubject.eraseToAnyPublisher()
    }
    var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        emailSubject
            .map {email in email != nil}
            .eraseToAnyPublisher()
    }
    var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        passwordSubject
            .map { password in password != nil }
            .eraseToAnyPublisher()
    }
    var isConfirmationValidPublisher: AnyPublisher<Bool, Never> {
        confirmationSubject
            .map { confirmation in confirmation != nil }
            .eraseToAnyPublisher()
    }
    var passwordsMatchPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest(onPasswordChangedPublisher, onConfirmationChangedPublisher)
            .map { password, confirmation in password == confirmation }
            .eraseToAnyPublisher()
    }
    var confirmedValidPasswordPublisher: AnyPublisher<Password?, Never> {
        Publishers
            .CombineLatest(passwordPublisher, passwordsMatchPublisher)
            .map { password, isMatching in isMatching ? password : nil }
            .eraseToAnyPublisher()
    }
    var validUserPublisher: AnyPublisher<User?, Never> {
        Publishers
            .CombineLatest(emailValuePublisher, confirmedValidPasswordPublisher)
            .map({email, password in
                guard let email, let password else { return nil }
                return User(email: email, password: password)
            })
            .eraseToAnyPublisher()
    }
    var isFormValidPublisher: AnyPublisher<Bool, Never> {
        validUserPublisher
            .map {validUser in validUser != nil}
            .eraseToAnyPublisher()
    }
    
   /* private var invalidEmailMessagePublisher: AnyPublisher<String?, Never> {
        isEmailValidPublisher
            .map { isValid in isValid ? nil : String(localized: .signupInvalidEmail) }
            .eraseToAnyPublisher()
    } */
    
    var emailPublisher: AnyPublisher<Result<Email, LocalizedStringResource>, Never> {
        emailValuePublisher
            .map({maybeEmail in
                guard let email = maybeEmail else { return .failure(.signupInvalidEmail)}
                return .success(email)
            })
            .eraseToAnyPublisher()
    }
    
    var invalidPasswordMessagePublisher: AnyPublisher<String?, Never> {
        isPasswordValidPublisher
            .map { isValid in isValid ? nil : String(localized: .signupInvalidPassword) }
            .eraseToAnyPublisher()
    }
    
    var invalidConfirmationMessagePublisher: AnyPublisher<String?, Never> {
        isConfirmationValidPublisher
            .map { isValid in isValid ? nil : String(localized: .signupInvalidPassword) }
            .eraseToAnyPublisher()
    }
    
    var passwordDiscrepancyMessagePublisher: AnyPublisher<String?, Never> {
        passwordsMatchPublisher
            .map { isMatching in isMatching ? nil : String(localized: .signupNotMatchingPassword) }
            .eraseToAnyPublisher()
    }
}

extension LocalizedStringResource: @retroactive LocalizedError {
    public var errorDescription: String? {
        String(localized: self)
    }
}
