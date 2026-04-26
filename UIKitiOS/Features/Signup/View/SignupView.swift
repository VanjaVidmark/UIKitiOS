//
//  SignupView.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

import UIKit

final class SignupView: UIView {

    var onEmailChanged: ((String) -> Void)?
    var onPasswordChanged: ((String) -> Void)?
    var onConfirmationChanged: ((String) -> Void)?
    var onSignupTapped: (() -> Void)?

    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: .signupWelcomeLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emailInputFieldView: InputFieldView = {
        InputFieldView<Email>(
            inputLabelText: .signupEmailLabel,
            placeholder: .signupEmailPlaceholder,
            errorLabelText: .signupInvalidEmail,
            keyboardType: .emailAddress,
            onEditingChanged: { [weak self] text in self?.onEmailChanged?(text) }
        )
    }()

    private lazy var passwordInputFieldView: InputFieldView = {
        InputFieldView<Password>(
            inputLabelText: .signupPasswordLabel,
            placeholder: .signupPasswordPlaceholder,
            errorLabelText: .signupInvalidPassword,
            isSecureTextEntry: true,
            onEditingChanged: { [weak self] text in self?.onPasswordChanged?(text) }
        )
    }()

    private lazy var passwordConfirmationInputFieldView: InputFieldView = {
        InputFieldView<Password>(
            inputLabelText: .signupConfirmPasswordLabel,
            placeholder: .signupPasswordPlaceholder,
            errorLabelText: .signupInvalidPassword,
            isSecureTextEntry: true,
            onEditingChanged: { [weak self] text in self?.onConfirmationChanged?(text) }
        )
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle(String(localized: .signupButtonTitle), for: .normal)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in self?.onSignupTapped?() }, for: .touchUpInside)
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

    func setButtonEnabled(_ enabled: Bool) {
        button.isEnabled = enabled
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
