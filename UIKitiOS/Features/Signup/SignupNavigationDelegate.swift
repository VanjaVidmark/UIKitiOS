//
//  SignupNavigationDelegate.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-29.
//

protocol SignupNavigationDelegate: AnyObject {
    func userSignedUp(jwt: JWT, user: User)
}
