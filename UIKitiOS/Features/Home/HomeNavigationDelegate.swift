
//
//  SignupNavigationDelegate.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

protocol HomeNavigationDelegate: AnyObject {
    func userSignedOut()
}

final class DummyHomeNavigationDelegate: HomeNavigationDelegate {
    func userSignedOut() {
        log.debug("About to navigate after successful sign out")
    }
    deinit {
        log.debug("deinit DummyHomeNavigationDelegate")
    }
}
