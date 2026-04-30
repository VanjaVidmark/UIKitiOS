//
//  SignupService.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

import Combine
import Foundation

protocol SignupService: AnyObject {
    func signup(user: User) -> AnyPublisher<JWT, ApiError>
}

final class DummySignupService: SignupService {
    private let queue = DispatchQueue(label: "networking", qos: .userInitiated)
    
    func signup(user: User) -> AnyPublisher<JWT, ApiError> {
        return Future<JWT, ApiError> { promise in
            promise(.success("this-is-a-token"))
        }
        .subscribe(on: queue)
        // Simulate real network latency
        .delay(for: .seconds(1), scheduler: queue)
        .eraseToAnyPublisher()
    }
}
