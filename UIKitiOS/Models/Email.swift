//
//  Email.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-24.
//

struct Email: Validating {
    let value: String
    
    init(raw: String) throws(Error) {
        guard !raw.isEmpty && raw.contains("@") else { throw Error.invalidEmail }
        self.value = raw
    }
    
    enum Error: Swift.Error {
        case invalidEmail
    }
}

extension Email: CustomStringConvertible {
    var description: String {
        value
    }
    
    #if DEBUG
        static let example: Self = try! .init(raw: "test@example.com")
    #endif
}
