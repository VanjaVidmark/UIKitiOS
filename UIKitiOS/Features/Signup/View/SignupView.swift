//
//  SignupView.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

import UIKit
import Combine

final class SignupView: UIView {
    
    private let onButtonTapSubject = PassthroughSubject<Void, Never>()

    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: .signupWelcomeLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailInputFieldView: InputFieldView = {
        let view = InputFieldView<Email>(
            inputLabelText: .signupEmailLabel,
            placeholder: .signupEmailPlaceholder,
            errorLabelText: .signupInvalidEmail,
            keyboardType: .emailAddress,
        )
        return view
    }()

    private lazy var passwordInputFieldView: InputFieldView = {
        let view = InputFieldView<Password>(
            inputLabelText: .signupPasswordLabel,
            placeholder: .signupPasswordPlaceholder,
            errorLabelText: .signupInvalidPassword,
            isSecureTextEntry: true,
        )
        return view
    }()

    private lazy var passwordConfirmationInputFieldView: InputFieldView = {
        let view = InputFieldView<Password>(
            inputLabelText: .signupConfirmPasswordLabel,
            placeholder: .signupPasswordPlaceholder,
            errorLabelText: .signupInvalidPassword,
            isSecureTextEntry: true,
        )
        return view
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle(String(localized: .signupButtonTitle), for: .normal)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in self?.onButtonTapSubject.send() }, for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            welcomeLabel,
            emailInputFieldView,
            passwordInputFieldView,
            passwordConfirmationInputFieldView,
            button
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .automatic
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        return scrollView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Publishers

extension SignupView {
    var onEmailChangedPublisher: AnyPublisher<String, Never> {
        emailInputFieldView.onEditingChangedPublisher
    }
    var onEmailEditingEndedPublisher: AnyPublisher<Void, Never> {
        emailInputFieldView.onEditingEndedPublisher
    }
    var onPasswordChangedPublisher: AnyPublisher<String, Never> {
        passwordInputFieldView.onEditingChangedPublisher
    }
    var onPasswordEditingEndedPublisher: AnyPublisher<Void, Never> {
        passwordInputFieldView.onEditingEndedPublisher
    }
    var onConfirmationChangedPublisher: AnyPublisher<String, Never> {
        passwordConfirmationInputFieldView.onEditingChangedPublisher
    }
    var onConfirmationEditingEndedPublisher: AnyPublisher<Void, Never> {
        passwordConfirmationInputFieldView.onEditingEndedPublisher
    }
    var onButtonTapPublisher: AnyPublisher<Void, Never> {
        onButtonTapSubject.eraseToAnyPublisher()
    }
}

// MARK: View Updates

extension SignupView {
    func setButtonEnabled(_ enabled: Bool) {
        button.isEnabled = enabled
    }

    func setEmailError(_ message: String?) {
        if let message { emailInputFieldView.showError(message) } else { emailInputFieldView.hideError() }
    }

    func setPasswordError(_ message: String?) {
        if let message { passwordInputFieldView.showError(message) } else { passwordInputFieldView.hideError() }
    }

    func setConfirmationError(_ message: String?) {
        if let message { passwordConfirmationInputFieldView.showError(message) } else { passwordConfirmationInputFieldView.hideError() }
    }
}

// MARK: Private

private extension SignupView {
    
    func setupLayout() {
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor),

            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }
}
