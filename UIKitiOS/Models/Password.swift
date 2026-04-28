//
//  Password.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-24.
//

struct Password: Validating, Equatable {
    let value: String
    static let minimumLength: Int = {
        #if DEBUG
        2
        #else
        8
        #endif
    }()
    
    init(raw: String) throws(Error) {
        guard !raw.isEmpty && raw.count >= Self.minimumLength else { throw Error.invalidPassword }
        self.value = raw
    }
    
    enum Error: Swift.Error {
        case invalidPassword
    }
}
