//
//  HomeView.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

import UIKit
import Combine

final class HomeView: UIView {
    
    private let onSignOutTappedSubject = PassthroughSubject<Void, Never>()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String(localized: .logOutButton), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] UIAction in self?.onSignOutTappedSubject.send()}, for: .touchUpInside)
        return button
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

// MARK: Combine

extension HomeView {
    var onSignOutTapped: AnyPublisher<Void, Never> {
        onSignOutTappedSubject.eraseToAnyPublisher()
    }
}

// MARK: Private

extension HomeView {
    private func setupLayout() {
        addSubview(logoutButton)
        addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            logoutButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            logoutButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
