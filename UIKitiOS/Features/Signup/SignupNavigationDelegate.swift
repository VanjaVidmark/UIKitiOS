//
//  SignupNavigationDelegate.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

protocol SignupNavigationDelegate: AnyObject {
    func userSignedUp(jwt: JWT, user: User)
}

final class DummySignupNavigationDelegate: SignupNavigationDelegate {
    func userSignedUp(jwt: JWT, user: User) {
        log.debug("About to navigate after successful sign up")
    }
    deinit {
        log.debug("deinit DummySignupNavigationDelegate")
    }
}
