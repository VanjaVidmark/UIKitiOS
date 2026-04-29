//
//  MockSignupNavigationDelegate.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

@testable import UIKitiOS
import XCTest

final class MockSignupNavigationDelegate: SignupNavigationDelegate {
    var wasUserSignedUpCalled = false
    let expectation: XCTestExpectation?
    
    init(expectation: XCTestExpectation? = nil) {
        self.expectation = expectation
    }

    func userSignedUp(jwt: JWT, user: User) {
        defer {
            wasUserSignedUpCalled = true
            expectation?.fulfill()
        }
        log.debug("About to navigate after successful sign up")
    }
}
