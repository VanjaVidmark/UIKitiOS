//
//  InputFieldView.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-24.
//

import UIKit
import Combine

class InputFieldView<Value: Validating>: UIView where Value.RawValue == String {
    private let inputLabel: UILabel
    private let textField: UITextField
    private let errorLabel: UILabel
    private let onEditingChangedSubject: PassthroughSubject<String, Never>
    private let onEditingEndedSubject = PassthroughSubject<Void, Never>()

    init(
        inputLabelText: LocalizedStringResource,
        placeholder: LocalizedStringResource,
        errorLabelText: LocalizedStringResource,
        keyboardType: UIKeyboardType = .default,
        isSecureTextEntry: Bool = false,
    ) {
        let onEditingChangedSubject = PassthroughSubject<String, Never>()
        inputLabel = UILabel.makeInputLabel(text: String(localized: inputLabelText))
        textField = UITextField.make(
            placeholderL10NKey: placeholder,
            keyboardType: keyboardType,
            isSecureTextEntry: isSecureTextEntry,
            onEditingChangedSubject: onEditingChangedSubject,
        )
        errorLabel = UILabel.makeErrorLabel(text: String(localized: errorLabelText))
        self.onEditingChangedSubject = onEditingChangedSubject
        
        super.init(frame: .zero)

        setupLayout()
        textField.addAction(UIAction { [weak self] _ in self?.onEditingEndedSubject.send() }, for: .editingDidEnd)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        let stackView = UIStackView(
            arrangedSubviews: [
                inputLabel,
                textField,
                errorLabel
            ]
        )
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension InputFieldView {
    
    var onEditingChangedPublisher: AnyPublisher<String, Never> {
        onEditingChangedSubject.eraseToAnyPublisher()
    }
    
    var onEditingEndedPublisher: AnyPublisher<Void, Never> {
        onEditingEndedSubject.eraseToAnyPublisher()
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    func hideError() {
        errorLabel.isHidden = true
    }
}
