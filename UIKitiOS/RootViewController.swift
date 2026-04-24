//
//  RootViewController.swift
//  UIKitiOS
//
//  Created by Alexander Cyon on 2026-04-23.
//

import UIKit

// MARK: RootViewController

final class RootViewController: UIViewController {
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: .signupWelcomeLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton.init(type: .roundedRect)
        button.setTitle(String(localized: .signupButtonTitle), for: .normal)
        button.addAction(UIAction{ [weak self] _ in self?.didTapSignupButton()}, for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var emailInputFieldView: InputFieldView = {
        let view = InputFieldView(
            inputLabelText: .signupEmailLabel,
            placeholder: .signupEmailPlaceholder,
            errorLabelText: .signupInvalidEmail,
            keyboardType: .emailAddress,
            onEditingChanged: {
                [weak self] _ in self?.configureSubviews()
            },
            onEditingEnded: {
                [weak self] _ in self?.configureSubviews(fieldToValidate: .email)
            }
        )
        return view
    }()
    
    private lazy var passwordInputFieldView: InputFieldView = {
        let view = InputFieldView(
            inputLabelText: .signupPasswordLabel,
            placeholder: .signupPasswordPlaceholder,
            errorLabelText: .signupInvalidPassword,
            isSecureTextEntry: true,
            onEditingChanged: {
                [weak self] _ in self?.configureSubviews()
            },
            onEditingEnded: {
                [weak self] _ in self?.configureSubviews(fieldToValidate: .password)
            }
        )
        return view
    }()
    
    private lazy var passwordConfirmationInputFieldView: InputFieldView = {
        let view = InputFieldView(
            inputLabelText: .signupConfirmPasswordLabel,
            placeholder: .signupPasswordPlaceholder,
            errorLabelText: .signupNotMatchingPassword,
            isSecureTextEntry: true,
            onEditingChanged: {
                [weak self] _ in self?.configureSubviews()
            },
            onEditingEnded: {
                [weak self] _ in self?.configureSubviews(fieldToValidate: .passwordConfirmation)
            }
        )
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                welcomeLabel,
                emailInputFieldView,
                passwordInputFieldView,
                passwordConfirmationInputFieldView,
                button,
                .spacer
            ]
        )
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
        return scrollView
    }()
}

// MARK: Override
extension RootViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }
}

// MARK: Private
private extension RootViewController {
    private func didTapSignupButton() {
        print("Tapped!")
    }
    
    var isValidEmail: Bool {
        let email = emailInputFieldView.text ?? ""
        return !email.isEmpty && email.contains("@")
    }
    
    var isValidPassword: Bool {
        let text = passwordInputFieldView.text ?? ""
        return !text.isEmpty && text.count >= 8
    }
    
    var doesPasswordMatch: Bool {
        passwordInputFieldView.text == passwordConfirmationInputFieldView.text
    }
    
    var canSignUp: Bool {
        return isValidEmail && isValidPassword && doesPasswordMatch
    }
    
    func configureSubviews(fieldToValidate: InputField? = nil) {
        
        button.isEnabled = canSignUp
        
        // Eagerly remove errors
        if (isValidEmail) { emailInputFieldView.isErrorHidden = true }
        if (isValidPassword) { passwordInputFieldView.isErrorHidden = true}
        if (doesPasswordMatch) { passwordConfirmationInputFieldView.isErrorHidden = true }
        
        // Lazily show errors
        switch fieldToValidate {
        case .email:
            if (!isValidEmail) {
                emailInputFieldView.isErrorHidden = false
            }
        case .password:
            if (!isValidPassword) {
                passwordInputFieldView.isErrorHidden = false
            }
        case .passwordConfirmation:
            if (!doesPasswordMatch) {
                passwordConfirmationInputFieldView.isErrorHidden = false
            }
        case .none:
            break
        }
    }
}

// MARK: Enum

enum InputField {
    case email
    case password
    case passwordConfirmation
}
