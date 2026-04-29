//
//  HomeViewModel.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

final class HomeViewModel {
    private let loggedInUser: User
    
    init(loggedInUser: User) {
        self.loggedInUser = loggedInUser
    }
}

extension HomeViewModel {
    var welcomeMessage: String { "Welcome, \(loggedInUser.email)" }
}
