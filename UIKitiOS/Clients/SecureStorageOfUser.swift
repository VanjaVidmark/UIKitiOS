//
//  SecureStorageOfUser.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

protocol SecureStorageOfUser: AnyObject {
    func saveUser(_ value: User) throws
    func loadUser() throws -> User?
    func clearUser()    
}

final class Insecure︕！StorageOfUser: SecureStorageOfUser {
    private static let userKey = "user"
    
    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    init(
        userDefaults: UserDefaults = .standard,
        jsonEncoder: JSONEncoder = JSONEncoder(),
        jsonDecoder: JSONDecoder = JSONDecoder(),
    ){
        self.userDefaults = userDefaults
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }
    
    func saveUser(_ user: User) throws {
        let data = try jsonEncoder.encode(user)
        userDefaults.set(data, forKey: Self.userKey)
    }
    
    func loadUser() throws -> User? {
        guard let data = userDefaults.data(forKey: Self.userKey) else { return nil }
        return try jsonDecoder.decode(User.self, from: data)
    }
    
    func clearUser() {
        userDefaults.removeObject(forKey: Self.userKey)
    }
}

extension Insecure︕！StorageOfUser {
    static let shared = Insecure︕！StorageOfUser()
}
