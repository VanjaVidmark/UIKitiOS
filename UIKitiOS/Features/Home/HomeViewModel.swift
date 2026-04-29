//
//  HomeViewModel.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

import Combine

final class HomeViewModel {
    private let loggedInUser: User

    private let userStorage: any SecureStorageOfUser
    private weak var navigator: (any HomeNavigationDelegate)?

    private var cancellables: Set<AnyCancellable> = []

    init(
        loggedInUser: User,
        onSignOutTappedPublisher: any Publisher<Void, Never>,
        userStorage: any SecureStorageOfUser,
        navigator: any HomeNavigationDelegate,
    ) {
        self.loggedInUser = loggedInUser
        self.userStorage = userStorage
        self.navigator = navigator
        
        onSignOutTappedPublisher
            .eraseToAnyPublisher()
            .sink { [weak self] _ in self?.userTappedSignOut() }
            .store(in: &cancellables)
    }
}

// MARK: Internal

extension HomeViewModel {
    var welcomeMessage: String { "Welcome, \(loggedInUser.email)" }
}

// MARK: Private

extension HomeViewModel {
    private func userTappedSignOut() {
        log.debug("Signing out. About to clear user and navigate")
        userStorage.clearUser()
        navigator?.userSignedOut()
    }
}
