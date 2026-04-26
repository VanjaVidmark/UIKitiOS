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
    private var result: Bool?

    override func setUp() {
        super.setUp()
        result = nil
        vm = SignupViewModel()
        vm.onFormValidityChanged = { [weak self] isValid in self?.result = isValid }
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
        XCTAssertEqual(result, false)
    }

    func test_onFormValidityChanged_onlyEmailValidReturnsFalse() {
        // Act
        vm.emailChanged("example@user.com")

        // Assert
        XCTAssertEqual(result, false)
    }

    func test_onFormValidityChanged_confirmationEmptyReturnsFalse() {
        // Act
        vm.emailChanged("example@user.com")
        vm.passwordChanged("password")

        // Assert
        XCTAssertEqual(result, false)
    }

    func test_onFormValidityChanged_passwordsNotMatchingReturnsFalse() {
        // Act
        vm.emailChanged("example@user.com")
        vm.passwordChanged("password")
        vm.passwordConfirmationChanged("anotherpassword")

        // Assert
        XCTAssertEqual(result, false)
    }

    func test_onFormValidityChanged_allValidReturnsTrue() {
        // Act
        vm.emailChanged("example@user.com")
        vm.passwordChanged("password")
        vm.passwordConfirmationChanged("password")

        // Assert
        XCTAssertEqual(result, true)
    }
}
