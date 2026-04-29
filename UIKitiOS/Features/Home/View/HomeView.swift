//
//  HomeView.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

import UIKit

final class HomeView: UIView {
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: View Updates

extension HomeView {
    func setWelcomeMessage(_ message: String) {
        welcomeLabel.text = message
    }
}

// MARK: Private

extension HomeView {
    private func setupLayout() {
        addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
