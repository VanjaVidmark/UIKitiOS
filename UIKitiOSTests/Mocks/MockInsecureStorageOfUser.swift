//
//  MockInsecureStorageOfUser.swift
//  UIKitiOS
//

@testable import UIKitiOS

final class MockUserStorageWithUser: SecureStorageOfUser {
    private let user: User

    init(user: User = .example) {
        self.user = user
    }

    func saveUser(_ value: User) throws {}
    func loadUser() throws -> User? { user }
    func clearUser() {}
    
    deinit {
        log.debug("Deinit MockUserStorageWithUser")
    }
}

final class MockEmptyUserStorage: SecureStorageOfUser {
    func saveUser(_ value: User) throws {}
    func loadUser() throws -> User? { nil }
    func clearUser() {}
    
    deinit {
        log.debug("Deinit MockEmptyUserStorage")
    }
}
