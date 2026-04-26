//
//  UIKitiOSTests.swift
//  UIKitiOSTests
//
//  Created by Vanja Vidmark on 2026-04-26.
//

import XCTest

@testable import UIKitiOS

final class ModelTests: XCTestCase {
    
    // MARK: Email init

    func test_email_init_validEmailValue() throws {
        // Arrange + Act
        let email = try Email(raw: "user@example.com")
        
        // Assert
        XCTAssertEqual(email.value, "user@example.com")
    }

    func test_email_init_emptyEmailValueThrows() {
        // Arrange + Act + Assert
        XCTAssertThrowsError(try Email(raw: "")) {
            error in XCTAssertEqual(error as? Email.Error, .invalidEmail)
        }
    }

    func test_email_init_emailWithoutAtsignThrows() {
        // Arrange + Act + Assert
        XCTAssertThrowsError(try Email(raw: "userexample")) {
            error in XCTAssertEqual(error as? Email.Error, .invalidEmail)
        }
    }
    
    // MARK: Password init
    
    func test_password_init_validPasswordValue() throws {
        // Arrange + Act
        let password = try Password(raw: "password")
        
        // Assert
        XCTAssertEqual(password.value, "password")
    }

    func test_password_init_emptyPasswordValueThrows() {
        // Arrange + Act + Assert
        XCTAssertThrowsError(try Password(raw: "")) {
            error in XCTAssertEqual(error as? Password.Error, .invalidPassword)
        }
    }

    func test_password_init_passwordShorterThanEightCharsThrows() {
        // Arrange + Act + Assert
        XCTAssertThrowsError(try Password(raw: "pass")) {
            error in XCTAssertEqual(error as? Password.Error, .invalidPassword)
        }
    }
}
