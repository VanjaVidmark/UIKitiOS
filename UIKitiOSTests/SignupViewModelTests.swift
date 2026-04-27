//
//  SignupViewModelTests.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

import XCTest
@testable import UIKitiOS

final class SignupViewModelTests: XCTestCase {

    private var vm: SignupViewModel!
    private var isFormValid: Bool?

    override func setUp() {
        super.setUp()
        isFormValid = nil
        vm = SignupViewModel()
        vm.onFormValidityChanged = { [weak self] isValid in self?.isFormValid = isValid }
    }

    override func tearDown() {
        vm = nil
        super.tearDown()
    }

    // MARK: onFormValidityChanged

    func test_onFormValidityChanged_allEmptyReturnsFalse() {
        // Act
        vm.emailChanged("")

        // Assert
        XCTAssertEqual(isFormValid, false)
    }

    func test_onFormValidityChanged_onlyEmailValidReturnsFalse() {
        // Act
        vm.emailChanged("example@user.com")

        // Assert
        XCTAssertEqual(isFormValid, false)
    }

    func test_onFormValidityChanged_confirmationEmptyReturnsFalse() {
        // Act
        vm.emailChanged("example@user.com")
        vm.passwordChanged("password")

        // Assert
        XCTAssertEqual(isFormValid, false)
    }

    func test_onFormValidityChanged_passwordsNotMatchingReturnsFalse() {
        // Act
        vm.emailChanged("example@user.com")
        vm.passwordChanged("password")
        vm.passwordConfirmationChanged("anotherpassword")

        // Assert
        XCTAssertEqual(isFormValid, false)
    }

    func test_onFormValidityChanged_allValidReturnsTrue() {
        // Act
        vm.emailChanged("example@user.com")
        vm.passwordChanged("password")
        vm.passwordConfirmationChanged("password")

        // Assert
        XCTAssertEqual(isFormValid, true)
    }
}
