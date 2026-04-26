//
//  SignupViewModelTests.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

import XCTest
@testable import UIKitiOS

final class SignupViewModelTests: XCTestCase {

    // What to test? there are many combinations of invalid forms? all invalid, all empty, 1 or 3 invalid 2 of 3 invalid etc
    
    // MARK: onFormValidityChange

    func test_onFormValidityChange_allEmptyReturnsFalse() {
        // Arrange
        var result: Bool?
        let vm = SignupViewModel()
        vm.onFormValidityChanged = { isValid in result = isValid }
        
        // Act
        vm.emailChanged("")
        
        // Assert
        XCTAssertEqual(result, false)
    }

    func test_onFormValidityChange_onlyEmailValidReturnsFalse() {
        // Arrange
        var result: Bool?
        let vm = SignupViewModel()
        vm.onFormValidityChanged = { isValid in result = isValid }
        
        // Act
        vm.emailChanged("example@user.com")
        
        // Assert
        XCTAssertEqual(result, false)
    }
    
    func test_onFormValidityChange_confirmationEmptyReturnsFalse() {
        // Arrange
        var result: Bool?
        let vm = SignupViewModel()
        vm.onFormValidityChanged = { isValid in result = isValid }
        
        // Act
        vm.emailChanged("example@user.com")
        vm.passwordChanged("password")
        
        // Assert
        XCTAssertEqual(result, false)
    }
    
    func test_onFormValidityChange_passwordsNotMatchingReturnsFalse() {
        // Arrange
        var result: Bool?
        let vm = SignupViewModel()
        vm.onFormValidityChanged = { isValid in result = isValid }
        
        // Act
        vm.emailChanged("example@user.com")
        vm.passwordChanged("password")
        vm.passwordConfirmationChanged("anotherpassword")
        
        // Assert
        XCTAssertEqual(result, false)
    }
    
    func test_onFormValidityChange_allValidReturnsTrue() {
        // Arrange
        var result: Bool?
        let vm = SignupViewModel()
        vm.onFormValidityChanged = { isValid in result = isValid }
        
        // Act
        vm.emailChanged("example@user.com")
        vm.passwordChanged("password")
        vm.passwordConfirmationChanged("password")
        
        // Assert
        XCTAssertEqual(result, true)
    }
}
