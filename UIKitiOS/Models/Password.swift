//
//  Password.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-24.
//

struct Password: Validating, Equatable {
    let value: String
    
    init(raw: String) throws(Error) {
        guard !raw.isEmpty && raw.count >= Self.minimumLength else { throw Error.invalidPassword }
        self.value = raw
    }
    
    enum Error: Swift.Error {
        case invalidPassword
    }
}

extension Password {
    private static let minLengthDebug: Int = 2
    private static let minLengthRelease: Int = 8
    
    static let minimumLength: Int = {
        #if DEBUG
        return NSClassFromString("XCTestCase") != nil ? minLengthRelease : minLengthDebug
        #else
        minLengthRelease
        #endif
    }()
    
    #if DEBUG
        static let example: Self = try! .init(raw: "password")
    #endif
}
