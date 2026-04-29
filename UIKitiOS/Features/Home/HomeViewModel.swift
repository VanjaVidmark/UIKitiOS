//
//  HomeViewModel.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

final class HomeViewModel {
    // Now that the state is not explicitly bound to the view (via a textfield)
    // the VM can hold the state?
    
    private var loggedInUser: User
    
    var welcomeMessage: String { "Welcome, \(loggedInUser.email)" }
    
    init(loggedInUser: User) {
        self.loggedInUser = loggedInUser
    }
}
