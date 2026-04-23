//
//  RootViewController.swift
//  UIKitiOS
//
//  Created by Alexander Cyon on 2026-04-23.
//

import UIKit

// MARK: RootViewController
final class RootViewController: UIViewController {
    private lazy var label: UILabel = {
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
    
    private lazy var emailTextField = UITextField.make(
        placeholderL10NKey: .signupEmailPlaceholder,
        keyboardType: .emailAddress,
        isSecureTextEntry: false,
        onEditingChanged: { [weak self] emailText in self?.configureSubviews()},
        onEditingEnded: { [weak self] _ in self?.configureSubviews(fieldToValidate: .email)}
    )
    
    private lazy var emailErrorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordTextField = UITextField.make(
        placeholderL10NKey: .signupPasswordPlaceholder,
        onEditingChanged: { [weak self] passwordText in self?.configureSubviews()},
        onEditingEnded: { [weak self] _ in self?.configureSubviews(fieldToValidate: .password)},
    )
    
    private lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordConfirmationTextField = UITextField.make(
        placeholderL10NKey: .signupPasswordPlaceholder,
        onEditingChanged: { [weak self] passwordConfirmation in self?.configureSubviews()},
        onEditingEnded: {[weak self] _ in self?.configureSubviews(fieldToValidate: .passwordConfirmation)}
    )
    
    private lazy var passwordConfirmationErrorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                label,
                emailTextField,
                emailErrorLabel,
                passwordTextField,
                passwordErrorLabel,
                passwordConfirmationTextField,
                passwordConfirmationErrorLabel,
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
        let email = emailTextField.text ?? ""
        return !email.isEmpty && email.contains("@")
    }
    
    var isValidPassword: Bool {
        let text = passwordTextField.text ?? ""
        return !text.isEmpty && text.count >= 8
    }
    
    var doesPasswordMatch: Bool {
        passwordTextField.text == passwordConfirmationTextField.text
    }
    
    var canSignUp: Bool {
        return isValidEmail && isValidPassword && doesPasswordMatch
    }
    
    func configureSubviews(fieldToValidate: InputField? = nil) {
        
        button.isEnabled = canSignUp
        
        // Eagerly remove errors
        if (isValidEmail) {emailErrorLabel.isHidden = true}
        if (isValidPassword) { passwordErrorLabel.isHidden = true}
        if (doesPasswordMatch) { passwordConfirmationErrorLabel.isHidden = true }
        
        // Lazily show errors
        switch fieldToValidate {
        case .email:
            if (!isValidEmail) {
                emailErrorLabel.text = String(localized: LocalizedStringResource .signupInvalidEmail)
                emailErrorLabel.isHidden = false
            }
        case .password:
            if (!isValidPassword) {
                passwordErrorLabel.text = String(localized: LocalizedStringResource .signupInvalidPassword)
                passwordErrorLabel.isHidden = false
            }
        case .passwordConfirmation:
            if (!doesPasswordMatch) {
                passwordConfirmationErrorLabel.text = String(localized: LocalizedStringResource .signupNotMatchingPassword)
                passwordConfirmationErrorLabel.isHidden = false
            }
        case .none:
            break
        }
    }
}

extension UITextField {
    static func make(
        placeholderL10NKey: LocalizedStringResource,
        keyboardType: UIKeyboardType = .default,
        isSecureTextEntry: Bool = true,
        onEditingChanged: @escaping (String) -> Void,
        onEditingEnded: @escaping (String) -> Void,
    ) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = isSecureTextEntry
        textField.placeholder = String(localized: placeholderL10NKey)
        textField.addAction(UIAction { _ in onEditingChanged(textField.text ?? "") }, for: .editingChanged)
        textField.addAction(UIAction {_ in onEditingEnded(textField.text ?? "")}, for: .editingDidEnd)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}

// MARK: Enum

enum InputField {
    case email
    case password
    case passwordConfirmation
}
