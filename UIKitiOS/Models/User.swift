//
//  User.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-28.
//

struct User {
    let email: Email
    let password: Password
}

extension User : CustomStringConvertible {
    var description: String {
        "User(email:\(email))"
    }
}

extension User: Equatable {}

extension User {
    #if DEBUG
    static let example: Self = .init(email: .example, password: .example)
    #endif
}
