//
//  SignupViewModelTests.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

import XCTest
import Combine
@testable import UIKitiOS

func sut(
    onEmailChangedPublisher: any Publisher<String, Never> = Empty(completeImmediately: true),
    onPasswordChangedPublisher: any Publisher<String, Never> = Empty(completeImmediately: true),
    onConfirmationChangedPublisher: any Publisher<String, Never> = Empty(completeImmediately: true),
    onButtonTapPublisher: any Publisher<Void, Never> = Empty(completeImmediately: true),
) -> SignupViewModel {
    SignupViewModel(
        onEmailChangedPublisher: onEmailChangedPublisher,
        onPasswordChangedPublisher: onPasswordChangedPublisher,
        onConfirmationChangedPublisher: onConfirmationChangedPublisher,
        onButtonTapPublisher: onButtonTapPublisher,
    )
}

final class SignupViewModelTests: XCTestCase {

    // MARK: invalidEmailMessagePublisher

    func test_invalidEmailMessagePublisher_whenInvalidEmail_thenEmits() async {
        // Arrange
        let emailSubject = PassthroughSubject<String, Never>()
        let vm = sut(onEmailChangedPublisher: emailSubject)
        var receivedValue: String?
        let expectation = XCTestExpectation(description: "Receive value")
        var cancellables: Set<AnyCancellable> = []

        vm.invalidEmailMessagePublisher.sink { value in
            receivedValue = value
            expectation.fulfill()
        }.store(in: &cancellables)

        // Act
        emailSubject.send("invalid-email")

        // Assert
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertEqual(receivedValue, String(localized: .signupInvalidEmail))
    }

    func test_invalidEmailMessagePublisher_whenEmptyEmail_thenEmits() async {
        // Arrange
        let emailSubject = PassthroughSubject<String, Never>()
        let vm = sut(onEmailChangedPublisher: emailSubject)
        var receivedValue: String?
        let expectation = XCTestExpectation(description: "Receive value")
        var cancellables: Set<AnyCancellable> = []

        vm.invalidEmailMessagePublisher.sink { value in
            receivedValue = value
            expectation.fulfill()
        }.store(in: &cancellables)

        // Act
        emailSubject.send("")

        // Assert
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertEqual(receivedValue, String(localized: .signupInvalidEmail))
    }

    func test_invalidEmailMessagePublisher_whenValidEmail_thenNil() async {
        // Arrange
        let emailSubject = PassthroughSubject<String, Never>()
        let vm = sut(onEmailChangedPublisher: emailSubject)
        var receivedValue: String?
        let expectation = XCTestExpectation(description: "Receive value")
        var cancellables: Set<AnyCancellable> = []

        vm.invalidEmailMessagePublisher.sink { value in
            receivedValue = value
            expectation.fulfill()
        }.store(in: &cancellables)

        // Act
        emailSubject.send("user@example.com")

        // Assert
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertNil(receivedValue)
    }
}

// MARK: Helpers

extension XCTestCase {
    
    
}
