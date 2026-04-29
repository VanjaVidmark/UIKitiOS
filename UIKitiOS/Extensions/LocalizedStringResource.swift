//
//  LocalizedStringResource.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-24.
//

import Foundation

extension LocalizedStringResource: @retroactive LocalizedError {
    public var errorDescription: String? {
        String(localized: self)
    }
    
    static func homeWelcome(email: String) -> LocalizedStringResource {
        LocalizedStringResource("homeWelcome", defaultValue: "Welcome, \(email)")
    }
}
