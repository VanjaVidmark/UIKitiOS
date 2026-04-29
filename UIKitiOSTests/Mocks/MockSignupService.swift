//
//  MockSignupService.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

import Combine
@testable import UIKitiOS

final class MockSignupService: SignupService {
    nonisolated(unsafe) var wasSignupCalled = false

    nonisolated func signup(user: User) -> AnyPublisher<JWT, ApiError> {
        defer {
            wasSignupCalled = true
        }
        return Just<JWT>("this-is-a-token")
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
}
