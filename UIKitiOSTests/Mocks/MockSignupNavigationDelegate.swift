//
//  MockSignupNavigationDelegate.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

@testable import UIKitiOS

final class MockSignupNavigationDelegate: SignupNavigationDelegate {
    var wasUserSignedUpCalled = false

    func userSignedUp(jwt: JWT) {
        defer {
            wasUserSignedUpCalled = true
        }
        log.debug("About to navigate after successful sign up")
    }
}
