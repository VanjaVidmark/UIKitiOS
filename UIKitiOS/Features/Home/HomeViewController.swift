//
//  HomeViewController.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let email: Email
    
    init(email: Email) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome \(email.value)"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

// MARK: Override

extension HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(welcomeLabel)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
                welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
}
