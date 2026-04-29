//
//  HomeVC.swift
//  UIKitiOS
//
//  Created by Alexander Cyon on 2026-04-23.
//

import UIKit
import Combine

final class HomeVC: UIViewController {
    
    private let homeViewModel: HomeViewModel
    private let homeView = HomeView()
    
    private lazy var cancellables = Set<AnyCancellable>()
    
    init() {
        // TODO: använd riktig user
        self.homeViewModel = HomeViewModel(loggedInUser: .example)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
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
        homeView.setWelcomeMessage(homeViewModel.welcomeMessage)
    }
}

