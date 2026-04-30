//
//  MockInsecureStorageOfUser.swift
//  UIKitiOS
//

@testable import UIKitiOS

final class MockUserStorage: SecureStorageOfUser {
    var user: User?

    init(
        initialUser: User?
    ) {
        self.user = initialUser
    }
    
    deinit {
        log.debug("Deinit MockUserStorage")
    }
}

extension MockUserStorage {
    func saveUser(_ value: User) throws {
        self.user = value
    }
    func loadUser() throws -> User? {
        user
    }
    func clearUser() {
        self.user = nil
    }
}

extension MockUserStorage {
    static func withUser() -> Self {
        Self.init(initialUser: .example)
    }
}
