//
//  SignupViewModel.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

import Foundation
import Combine

final class SignupViewModel {
    
    // Received from view. Used to react to user interactions
    private let onEmailChangedPublisher: AnyPublisher<String, Never>
    private let onPasswordChangedPublisher: AnyPublisher<String, Never>
    private let onConfirmationChangedPublisher: AnyPublisher<String, Never>
    private let onButtonTapPublisher: AnyPublisher<Void, Never>
    
    private weak var signupService: (any SignupService)?
    private weak var navigator: (any SignupNavigationDelegate)?
    private weak var userStorage: (any SecureStorageOfUser)?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // Created in vm
    private let emailSubject = PassthroughSubject<Email?, Never>()
    private let passwordSubject = PassthroughSubject<Password?, Never>()
    private let confirmationSubject = PassthroughSubject<Password?, Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    
    init(
        onEmailChangedPublisher: any Publisher<String, Never>,
        onPasswordChangedPublisher: any Publisher<String, Never>,
        onConfirmationChangedPublisher: any Publisher<String, Never>,
        onButtonTapPublisher: any Publisher<Void, Never>,
        signupService: SignupService,
        navigator: any SignupNavigationDelegate,
        userStorage: any SecureStorageOfUser,
    ) {
        self.signupService = signupService
        self.navigator = navigator
        self.userStorage = userStorage
        self.onEmailChangedPublisher = onEmailChangedPublisher.eraseToAnyPublisher()
        self.onEmailChangedPublisher
            .map { rawEmail in try? Email(raw: rawEmail) }
            .sink(receiveValue: { [weak emailSubject] email in emailSubject?.send(email)})
            .store(in: &cancellables)
        
        self.onPasswordChangedPublisher = onPasswordChangedPublisher.eraseToAnyPublisher()
        self.onPasswordChangedPublisher
            .map { rawPassword in try? Password(raw: rawPassword)}
            .sink(receiveValue: { [weak passwordSubject] password in passwordSubject?.send(password)})
            .store(in: &cancellables)
        
        self.onConfirmationChangedPublisher = onConfirmationChangedPublisher.eraseToAnyPublisher()
        self.onConfirmationChangedPublisher
            .map { rawConfirmation in try? Password(raw: rawConfirmation)}
            .sink(receiveValue: { [weak confirmationSubject] confirmation in confirmationSubject?.send(confirmation)})
            .store(in: &cancellables)
        
        self.onButtonTapPublisher = onButtonTapPublisher.eraseToAnyPublisher()
        self.onButtonTapPublisher
            .combineLatest(validUserPublisher.filterOutNil())
            .map { _, user in user }
            .sink(receiveValue: { [weak self] user in
                self?.onSignupTapped(user: user)
            })
            .store(in: &cancellables)
    }
}

// MARK: Internal

extension SignupViewModel {
    
    /*
    var isFormValidPublisher: AnyPublisher<Bool, Never> {
        validUserPublisher
            .map {validUser in validUser != nil}
            .eraseToAnyPublisher()
    }*/
    
    var isButtonEnabledPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(validUserPublisher, isLoadingSubject.prepend(false))
            .map { validUser, isLoading in validUser != nil && !isLoading }
            .eraseToAnyPublisher()
    }
    
    var invalidEmailMessagePublisher: AnyPublisher<String?, Never> {
        isEmailValidPublisher
            .map { isValid in isValid ? nil : String(localized: .signupInvalidEmail) }
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

// MARK: Private

extension SignupViewModel {
    
    func onSignupTapped(user: User) {
        guard let signupService else {
            log.warning("signupService is nil. Will not sign up")
            return
        }
        
        isLoadingSubject.send(true)
        signupService.signup(user: user)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    case .finished:
                        log.debug("Signup publisher finished")
                    case let .failure(error):
                        log.error("\(error)")
                        log.debug("Here I would display the error to the user")
                        self?.isLoadingSubject.send(false)
                }
            }, receiveValue: { [weak self] value in self?.userDidSignUp(jwt: value, user: user)
            })
            .store(in: &cancellables)
    }
    
    private func userDidSignUp(jwt: String, user: User) {
        log.debug("Successful signup. About to save user and navigate.")
        do {
            try userStorage?.saveUser(user)
        } catch {
            log.error("Failed to save user: \(error)")
        }
        navigator?.userSignedUp(jwt: jwt, user: user)
    }
    
    private var emailPublisher: AnyPublisher<Email?, Never> {
        emailSubject.eraseToAnyPublisher()
    }
    private var passwordPublisher: AnyPublisher<Password?, Never> {
        passwordSubject.eraseToAnyPublisher()
    }
    private var confirmationPublisher: AnyPublisher<Password?, Never> {
        confirmationSubject.eraseToAnyPublisher()
    }
    
    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        emailSubject
            .map {email in email != nil}
            .eraseToAnyPublisher()
    }
    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        passwordSubject
            .map { password in password != nil }
            .eraseToAnyPublisher()
    }
    private var isConfirmationValidPublisher: AnyPublisher<Bool, Never> {
        confirmationSubject
            .map { confirmation in confirmation != nil }
            .eraseToAnyPublisher()
    }
    private var passwordsMatchPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest(onPasswordChangedPublisher, onConfirmationChangedPublisher)
            .map { password, confirmation in password == confirmation }
            .eraseToAnyPublisher()
    }
    private var confirmedValidPasswordPublisher: AnyPublisher<Password?, Never> {
        Publishers
            .CombineLatest(passwordPublisher, passwordsMatchPublisher)
            .map { password, isMatching in isMatching ? password : nil }
            .eraseToAnyPublisher()
    }
    
    private var validUserPublisher: AnyPublisher<User?, Never> {
        Publishers
            .CombineLatest(emailPublisher, confirmedValidPasswordPublisher)
            .map({email, password in
                guard let email, let password else { return nil }
                let user = User(email: email, password: password)
                log.debug("\(user)")
                return user
            })
            .eraseToAnyPublisher()
    }
    
}
