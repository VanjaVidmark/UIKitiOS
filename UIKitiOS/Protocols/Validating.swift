//
//  Validating.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-26.
//

protocol Validating {
    associatedtype Error: Swift.Error
    associatedtype RawValue
    
    init(raw: RawValue) throws(Error)
}
