//
//  UILabel.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-24.
//

import UIKit

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
