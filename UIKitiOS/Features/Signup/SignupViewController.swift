//
//  SignupViewController.swift
//  UIKitiOS
//
//  Created by Alexander Cyon on 2026-04-23.
//

import UIKit

// MARK: SignupViewController

final class SignupViewController: UIViewController {
    
    private let onSignupTapped: (Email) -> Void
    
    init(onSignupTapped: @escaping (Email) -> Void) {
        self.onSignupTapped = onSignupTapped
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                [weak self] _ in self?.configureSubviews()
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
                [weak self] _ in self?.configureSubviews()
            },
        )
        return view
    }()
    
    private lazy var passwordConfirmationInputFieldView: InputFieldView = {
        let view = InputFieldView<Password>(
            inputLabelText: .signupConfirmPasswordLabel,
            placeholder: .signupPasswordPlaceholder,
            errorLabelText: .signupInvalidPassword,
            isSecureTextEntry: true,
            onEditingChanged: {
                [weak self] _ in self?.configureSubviews()
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

extension SignupViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
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

private extension SignupViewController {
    
    func didTapSignupButton() {
        guard let result =  validateInputFields() else { return }
        onSignupTapped(result.0)
    }
    
    func configureSubviews() {
        guard validateInputFields() != nil else {
            button.isEnabled = false
            return
        }
        button.isEnabled = true
    }
    
    func validateInputFields() -> (Email, Password, Password)? {
        guard
            let email = emailInputFieldView.validateInput(),
            let password = passwordInputFieldView.validateInput(),
            let confirmation = passwordConfirmationInputFieldView.validateInput()
        else {
            return nil
        }

        guard password == confirmation else {
            passwordConfirmationInputFieldView.showError(String(localized: .signupNotMatchingPassword))
            return nil
        }

        return (email, password, confirmation)
    }
}
