//
//  Publisher.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-24.
//

import Combine

public protocol OptionalProtocol {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalProtocol {
    public var value: Wrapped? {
        self
    }
}

extension Publisher where Output: OptionalProtocol {
    public func filterOutNil() -> AnyPublisher<Output.Wrapped, Failure> {
        compactMap { maybeOutput in
            guard let unwrapped = maybeOutput.value else {
                return nil
            }
            return unwrapped
        }.eraseToAnyPublisher()
    }
}
