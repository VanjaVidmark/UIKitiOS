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

final class Box<Value> {
    var value: Value?
    
    init(value: Value? = nil) {
        self.value = value
    }
}

final class SignupViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    override func tearDown() {
        cancellables.forEach {c in c.cancel()}
        cancellables.removeAll()
    }
    
    // MARK: invalidEmailMessagePublisher
    
    func test_invalidEmailMessagePublisher_whenInvalidEmail_thenEmits() async {
        // Arrange
        let emailSubject = PassthroughSubject<String, Never>()
        let sut = sut(onEmailChangedPublisher: emailSubject)
        let sink = Box<String?>()
        
        // Act
        let expectation = expectEmittedValue(
            from: sut.invalidEmailMessagePublisher,
            sink: sink,
        )
        emailSubject.send("invalid-email")
        
        // Assert
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertEqual(sink.value, String(localized: .signupInvalidEmail))
    }
    
    func test_invalidEmailMessagePublisher_whenEmptyEmail_thenEmits() async {
        // Arrange
        let emailSubject = PassthroughSubject<String, Never>()
        let sut = sut(onEmailChangedPublisher: emailSubject)
        let sink = Box<String?>()
        
        // Act
        let expectation = expectEmittedValue(
            from: sut.invalidEmailMessagePublisher,
            sink: sink,
        )
        emailSubject.send("")
        
        // Assert
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertEqual(sink.value, String(localized: .signupInvalidEmail))
    }
    
    func test_invalidEmailMessagePublisher_whenValidEmail_thenNil() async {
        // Arrange
        let emailSubject = PassthroughSubject<String, Never>()
        let sut = sut(onEmailChangedPublisher: emailSubject)
        let sink = Box<String?>()
        
        // Act
        let expectation = expectEmittedValue(
            from: sut.invalidEmailMessagePublisher,
            sink: sink,
        )
        emailSubject.send("user@example.com")
        
        // Assert
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertNil((sink.value ?? ""))
    }
    
    
    // MARK: isFormValidPublisher
    
    func test_isFormValidPublisher_whenAllFieldsValid_thenEmits() async {
        // Arrange
        let emailSubject = PassthroughSubject<String, Never>()
        let passwordSubject = PassthroughSubject<String, Never>()
        let confirmPasswordSubject = PassthroughSubject<String, Never>()
        let sut = sut(
            onEmailChangedPublisher: emailSubject,
            onPasswordChangedPublisher: passwordSubject,
            onConfirmationChangedPublisher: confirmPasswordSubject,
        )
        let sink = Box<Bool>()
        
        // Act
        let expectation = expectEmittedValue(
            from: sut.isFormValidPublisher,
            sink: sink,
        )
        
        emailSubject.send("valid@email.com")
        passwordSubject.send("strongPassword123")
        confirmPasswordSubject.send("strongPassword123")
        
        // Assert
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertTrue(try XCTUnwrap(sink.value))
    }
}

// MARK: Helpers

extension SignupViewModelTests {
    
    private func expectEmittedValue<Value>(
        from publisher: any Publisher<Value, Never>,
        sink boxToWriteTo: Box<Value>
    ) -> XCTestExpectation {
        let expectation = XCTestExpectation(description: "Receive value")
        
        publisher.sink { value in
            boxToWriteTo.value = value
            expectation.fulfill()
        }.store(in: &cancellables)
        
        return expectation
    }
    
    
}
