//
//  SignupViewModel.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//


final class SignupViewModel {
    private var email = ""
    private var password = ""
    private var passwordConfirmation = ""
    var onFormValidityChanged: ((Bool) -> Void)?
    
    
    private var isFormValid: Bool {
        guard
            let _ = try? Email(raw: email),
            let validPassword = try? Password(raw: password),
            let validPasswordConfirmation = try? Password(raw: passwordConfirmation)
        else {
            return false
        }
        
        return validPassword == validPasswordConfirmation
    }

    func emailChanged(_ text: String) {
        email = text
        onFormValidityChanged?(isFormValid)
    }
    
    func passwordChanged(_ text: String) {
        password = text
        onFormValidityChanged?(isFormValid)
    }
    
    func passwordConfirmationChanged(_ text: String) {
        passwordConfirmation = text
        onFormValidityChanged?(isFormValid)
    }
    
    
}
