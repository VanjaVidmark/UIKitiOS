//
//  MockSignupNavigationDelegate.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

@testable import UIKitiOS

final class MockSignupNavigationDelegate: SignupNavigationDelegate {
    nonisolated(unsafe) var wasUserSignedUpCalled = false

    nonisolated func userSignedUp(jwt: JWT) {
        defer {
            wasUserSignedUpCalled = true
        }
        log.debug("About to navigate after successful sign up")
    }
}
