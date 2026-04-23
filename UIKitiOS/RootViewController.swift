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
        onEditingChanged: { emailText in print("Email editing changed: \(emailText)")}
    )
    
    private lazy var passwordTextField = UITextField.make(
        placeholderL10NKey: .signupPasswordPlaceholder,
        onEditingChanged: {
            passwordText in print(
                "Password editing changed: \(passwordText)"
            )
        })
    
    private lazy var passwordConfirmationTextField = UITextField.make(
        placeholderL10NKey: .signupPasswordPlaceholder,
        onEditingChanged: {
            passwordConfirmation in print("Password confirmation editing changed: \(passwordConfirmation)" )
        })
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                label,
                emailTextField,
                passwordTextField,
                passwordConfirmationTextField,
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
        view.backgroundColor = .red

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
}

extension UITextField {
    static func make(
        placeholderL10NKey: LocalizedStringResource,
        keyboardType: UIKeyboardType = .default,
        isSecureTextEntry: Bool = true,
        onEditingChanged: @escaping (String) -> Void,
    ) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = isSecureTextEntry
        textField.placeholder = String(localized: placeholderL10NKey)
        textField.addAction(UIAction { _ in onEditingChanged(textField.text ?? "") }, for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
