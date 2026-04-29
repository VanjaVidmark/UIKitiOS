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
    
    private let queue = DispatchQueue(label: "networking", qos: .userInitiated)
    
    func signup(user: User) -> AnyPublisher<JWT, ApiError> {
        defer {
            userSignedUp = user
        }
        return Future<JWT, ApiError> { promise in
            promise(.success("mock-token"))
        }
        .subscribe(on: queue)
        .eraseToAnyPublisher()
    }
    
    deinit {
        log.debug("mockSignupService deinit")
    }
}
