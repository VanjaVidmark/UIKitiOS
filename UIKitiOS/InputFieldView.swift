//
//  InputFieldView.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-24.
//

import UIKit

class InputFieldView: UIView {
    private let inputLabel: UILabel
    private let textField: UITextField
    private let errorLabel: UILabel
    
    // Temporary? Not sure if i still need to expose this after moving validation logic in here. 
    var text: String? { textField.text }

    var isErrorHidden: Bool {
        get { errorLabel.isHidden }
        set { errorLabel.isHidden = newValue }
    }

    init(
        inputLabelText: LocalizedStringResource,
        placeholder: LocalizedStringResource,
        errorLabelText: LocalizedStringResource,
        keyboardType: UIKeyboardType = .default,
        isSecureTextEntry: Bool = false,
        onEditingChanged: @escaping (String) -> Void,
        onEditingEnded: @escaping (String) -> Void
    ) {
        inputLabel = UILabel.makeInputLabel(text: String(localized: inputLabelText))
        textField = UITextField.make(
            placeholderL10NKey: placeholder,
            keyboardType: keyboardType,
            isSecureTextEntry: isSecureTextEntry,
            onEditingChanged: onEditingChanged,
            onEditingEnded: onEditingEnded
        )
        errorLabel = UILabel.makeErrorLabel(text: String(localized: errorLabelText))
        super.init(frame: .zero)
        setupLayout()
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

extension UILabel {
    static func makeInputLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func makeErrorLabel(text: String) -> UILabel {
        let label = UILabel()
        label.isHidden = true
        label.text = text
        label.textColor = .red
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        textField.addAction(UIAction { _ in onEditingEnded(textField.text ?? "") }, for: .editingDidEnd)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
