//
//  Spacer.swift
//  UIKitiOS
//
//  Created by Isabella Viksten on 2026-04-23.
//

import UIKit

extension UIView {
    static func spacer(
        verticalCompressionResistancePriority: UILayoutPriority = .medium,
        verticalContentHuggingPriority: UILayoutPriority = .medium
    ) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false

        spacer.setContentCompressionResistancePriority(.medium, for: .horizontal)
        spacer.setContentCompressionResistancePriority(verticalCompressionResistancePriority, for: .vertical)

        spacer.setContentHuggingPriority(.medium, for: .horizontal)
        spacer.setContentHuggingPriority(verticalContentHuggingPriority, for: .vertical)
        spacer.backgroundColor = .clear
        return spacer
    }

    static var spacer: UIView {
        spacer()
    }

    static func spacer(height: CGFloat) -> UIView {
        let spacer: UIView = .spacer
        NSLayoutConstraint.activate([
            spacer.heightAnchor.constraint(equalToConstant: height)
        ])
        return spacer
    }
}

extension UILayoutPriority: @retroactive ExpressibleByFloatLiteral {
    public init(floatLiteral rawValue: Float) {
        self.init(rawValue: rawValue)
    }
}

extension UILayoutPriority: @retroactive ExpressibleByIntegerLiteral {
    public init(integerLiteral intValue: Int) {
        self.init(rawValue: Float(intValue))
    }
}

public extension UILayoutPriority {
    static var medium: UILayoutPriority {
        let delta = UILayoutPriority.defaultHigh.rawValue - UILayoutPriority.defaultLow.rawValue
        let valueBetweenLowAndHeight = UILayoutPriority.defaultLow.rawValue + delta / 2
        return UILayoutPriority(rawValue: valueBetweenLowAndHeight)
    }
}
