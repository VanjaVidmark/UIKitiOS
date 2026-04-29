//
//  InsecureStorageOfUserTest.swift
//  UIKitiOSTests
//
//  Created by Vanja Vidmark on 2026-04-29.
//

import XCTest
@testable import UIKitiOS

final class InsecureStorageOfUserTest: XCTestCase {
    func test_roundTrip() async throws /* needed to bypass xcode26.1 bug forums.swift.org/t/84034 */ {
        let sut = Insecure︕！StorageOfUser()
        let user: User = .example
        
        try sut.saveUser(user)
        let retrievedUser: User? = try sut.loadUser()
        
        XCTAssertEqual(user, retrievedUser)
    }
}
