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
        let view = InputFieldView<Email>(
            inputLabelText: .signupEmailLabel,
            placeholder: .signupEmailPlaceholder,
            errorLabelText: .signupInvalidEmail,
            keyboardType: .emailAddress,
            onEditingChanged: {
                [weak self] _ in self?.configureSubviews(fieldToValidate: .email)
            },
        )
        return view
    }()
    
    private lazy var passwordInputFieldView: InputFieldView = {
        let view = InputFieldView<Password>(
            inputLabelText: .signupPasswordLabel,
            placeholder: .signupPasswordPlaceholder,
            errorLabelText: .signupInvalidPassword,
            isSecureTextEntry: true,
            onEditingChanged: {
                [weak self] _ in self?.configureSubviews(fieldToValidate: .password)
            },
        )
        return view
    }()
    
    private lazy var passwordConfirmationInputFieldView: InputFieldView = {
        let view = InputFieldView<Password>(
            inputLabelText: .signupConfirmPasswordLabel,
            placeholder: .signupPasswordPlaceholder,
            errorLabelText: .signupNotMatchingPassword,
            isSecureTextEntry: true,
            onEditingChanged: {
                [weak self] _ in self?.configureSubviews(fieldToValidate: .passwordConfirmation)
            },
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
    
    var canSignUp: Bool {
        let emailValue: Email? = emailInputFieldView.validateInput()
        let passwordValue: Password? = passwordInputFieldView.validateInput()
        let passwordConfirmationValue: Password? = passwordConfirmationInputFieldView.validateInput()
        
        return emailValue != nil &&
        passwordValue != nil &&
        passwordConfirmationValue != nil &&
        passwordValue == passwordConfirmationValue
    }
    
    func configureSubviews(fieldToValidate: InputField? = nil) {
        
        button.isEnabled = canSignUp
        _ = emailInputFieldView.validateInput(removeError: true)
        _ = passwordInputFieldView.validateInput(removeError: true)
        _ = passwordConfirmationInputFieldView.validateInput(removeError: true)
        
        /*
        switch fieldToValidate {
        case .email:
            _ = emailInputFieldView.validateInput(removeError: true)
        case .password:
            _ = passwordInputFieldView.validateInput(removeError: true)
        case .passwordConfirmation:
            _ = passwordConfirmationInputFieldView.validateInput(removeError: true)
        case .none:
            break
        }
         */
    }
}

// MARK: Enum

enum InputField {
    case email
    case password
    case passwordConfirmation
}
