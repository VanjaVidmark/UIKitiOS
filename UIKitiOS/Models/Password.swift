//
//  Password.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-24.
//

struct Password: Validating, Equatable {
    let value: String
    
    init(raw: String) throws(Error) {
        guard !raw.isEmpty && raw.count >= 8 else { throw Error.invalidPassword }
        self.value = raw
    }
    
    enum Error: Swift.Error {
        case invalidPassword
    }
}
