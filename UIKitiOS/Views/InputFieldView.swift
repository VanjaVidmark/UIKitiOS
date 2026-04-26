//
//  InputFieldView.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-24.
//

import UIKit

class InputFieldView<Value: Validating>: UIView where Value.RawValue == String {
    private let inputLabel: UILabel
    private let textField: UITextField
    private let errorLabel: UILabel
    
    init(
        inputLabelText: LocalizedStringResource,
        placeholder: LocalizedStringResource,
        errorLabelText: LocalizedStringResource,
        keyboardType: UIKeyboardType = .default,
        isSecureTextEntry: Bool = false,
        onEditingChanged: @escaping (String) -> Void,
    ) {
        inputLabel = UILabel.makeInputLabel(text: String(localized: inputLabelText))
        textField = UITextField.make(
            placeholderL10NKey: placeholder,
            keyboardType: keyboardType,
            isSecureTextEntry: isSecureTextEntry,
            onEditingChanged: onEditingChanged,
        )
        errorLabel = UILabel.makeErrorLabel(text: String(localized: errorLabelText))
        
        super.init(frame: .zero)
        
        setupLayout()
        textField.addAction(UIAction { [weak self] _ in _ = self?.validateInput(showError: true) }, for: .editingDidEnd)
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

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    func validateInput(showError: Bool = false) -> Value? {
        do {
            let value = try Value.init(raw: textField.text ?? "")
            errorLabel.isHidden = true
            return value
        } catch {
            
            if showError {
                errorLabel.isHidden = false
            }
            return nil
        }
    }
}

