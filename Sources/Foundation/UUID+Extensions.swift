//
//  UUID+Extensions.swift
//  Copyright © 2025 Jason Fieldman.
//

import Foundation

public extension UUID {
    /// Returns the explicitly-lowercased UUID string
    var lowercaseUUIDString: String {
        uuidString.lowercased(with: .enUS)
    }

    /// Returns the explicitly-uppercased UUID string
    var uppercaseUUIDString: String {
        uuidString.uppercased(with: .enUS)
    }
}
