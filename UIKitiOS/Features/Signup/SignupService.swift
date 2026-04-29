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
    private let queue = DispatchQueue(label: "networking", qos: .background)
    
    func signup(user: User) -> AnyPublisher<JWT, ApiError> {
        Future<JWT, ApiError> { promise in
            promise(.success("this-is-a-token"))
        }
        .receive(on: queue)
        .eraseToAnyPublisher()
    }
}
