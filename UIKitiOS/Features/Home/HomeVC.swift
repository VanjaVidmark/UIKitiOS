//
//  HomeVC.swift
//  UIKitiOS
//
//  Created by Alexander Cyon on 2026-04-23.
//

import UIKit
import Combine

final class HomeVC: UIViewController {
    
    private let viewModel: HomeViewModel
    private let homeView = HomeView()
    
    init(loggedInUser: User) {
        self.viewModel = HomeViewModel(loggedInUser: loggedInUser)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Override

extension HomeVC {

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        homeView.setWelcomeMessage(viewModel.welcomeMessage)
    }
}

