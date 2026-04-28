//
//  Result.swift
//  UIKitiOS
//
//  Created by Vanja Vidmark on 2026-04-28.
//

extension Result {
    var failure: Failure? {
        switch self {
            case .success: return nil
            case .failure(let failure): return failure
        }
    }
}
