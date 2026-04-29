//
//  SignupService.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

import Combine

protocol SignupService: AnyObject {
    func signup(user: User) -> AnyPublisher<JWT, ApiError>
}

final class DummySignupService: SignupService {
    func signup(user: User) -> AnyPublisher<JWT, ApiError> {
        Just<JWT>("this-is-a-token")
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
}
