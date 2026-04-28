//
//  RootViewController.swift
//  UIKitiOS
//
//  Created by Alexander Cyon on 2026-04-23.
//

import UIKit
import Combine

final class RootViewController: UIViewController {
    
    private let signupViewModel: SignupViewModel
    private let signupView: SignupView
    
    private lazy var cancellables = Set<AnyCancellable>()
    
    init() {
        self.signupView = SignupView()
        
        let vm = SignupViewModel(
            onEmailChangedPublisher: self.signupView.onEmailChangedPublisher,
            onPasswordChangedPublisher: self.signupView.onPasswordChangedPublisher,
            onConfirmationChangedPublisher: self.signupView.onConfirmationChangedPublisher,
            onButtonTap: self.signupView.onButtonTapPublisher
        )
        
        self.signupViewModel = vm
        super.init(nibName: nil, bundle: nil)
        
        vm.invalidEmailMessagePublisher
            .sink(receiveValue: { [weak self] localizedError in self?.signupView.setEmailError(localizedError) })
            .store(in: &cancellables)
        
        vm.invalidPasswordMessagePublisher
            .sink(receiveValue: { [weak self] localizedError in self?.signupView.setPasswordError(localizedError) })
            .store(in: &cancellables)
        
        vm.invalidConfirmationMessagePublisher
            .sink(receiveValue: { [weak self] localizedError in self?.signupView.setConfirmationError(localizedError) })
            .store(in: &cancellables)
        
        vm.passwordDiscrepancyMessagePublisher
            .sink(receiveValue: { [weak self] localizedError in self?.signupView.setConfirmationError(localizedError) })
            .store(in: &cancellables)
        
        vm.isFormValidPublisher
            .sink(receiveValue: { [weak self] isFormValid in self?.signupView.setButtonEnabled(isFormValid) })
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Override

extension RootViewController {

    override func loadView() {
        view = signupView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

