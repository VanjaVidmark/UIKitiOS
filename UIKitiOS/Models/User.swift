//
//  User.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-28.
//

struct User: CustomStringConvertible {
    let email: Email
    let password: Password
}

extension User {
    var description: String {
        "User(email:\(email))"
    }
}
