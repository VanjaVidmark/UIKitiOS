//
//  UITextField.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-24.
//

import UIKit
import Combine

extension UITextField {
    static func make(
        placeholderL10NKey: LocalizedStringResource,
        keyboardType: UIKeyboardType = .default,
        isSecureTextEntry: Bool = false,
    ) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = isSecureTextEntry
        textField.placeholder = String(localized: placeholderL10NKey)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
