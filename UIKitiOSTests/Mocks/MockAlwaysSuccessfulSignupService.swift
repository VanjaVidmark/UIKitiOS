//
//  MockSignupService.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

import Combine
@testable import UIKitiOS

final class MockAlwaysSuccessfulSignupService: SignupService {
    nonisolated(unsafe) var userSignedUp: User? = nil

    nonisolated func signup(user: User) -> AnyPublisher<JWT, ApiError> {
        defer {
            userSignedUp = user
        }
        return Just<JWT>("this-is-a-token")
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    deinit {
        log.debug("mockSignupService deinit")
    }
}
