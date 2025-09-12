//
//  RawRepresentable+Extensions.swift
//  Copyright © 2025 Jason Fieldman.
//

import Foundation

/// A collection of extensions for types conforming to `RawRepresentable`.
public extension RawRepresentable {
    /// Initializes a new instance of the conforming type using an optional raw value.
    ///
    /// - Parameter optionalRawValue: The raw value to use for initialization, or `nil` if the instance should not be initialized.
    /// - Returns: A new instance of the conforming type if the raw value is valid, otherwise `nil`.
    init?(optionalRawValue: RawValue?) {
        guard let optionalRawValue else {
            return nil
        }
        self.init(rawValue: optionalRawValue)
    }
}

/// A collection of case-insensitive matching extensions for `RawRepresentable` types that also conform to `CaseIterable` and have a `String` raw value.
public extension RawRepresentable where RawValue == String, Self: CaseIterable {
    /// Attempts to find a case-insensitive match for a given string among the cases of the conforming type.
    ///
    /// This method first attempts an exact match, then tries lowercased and uppercased versions of the needle string.
    /// If those fail, it performs a case-insensitive search through all cases.
    ///
    /// - Parameter needle: The string to match against the cases, or `nil` if no match should be attempted.
    /// - Returns: The matching case if found, otherwise `nil`.
    static func caseInsensitive(matching needle: String?) -> Self? {
        guard let needle else {
            return nil
        }

        if let match = Self(rawValue: needle) {
            return match
        }

        let lowercasedNeedle = needle.lowercased(with: .enUS)

        if let match = Self(rawValue: lowercasedNeedle) {
            return match
        }

        if let match = Self(rawValue: needle.uppercased(with: .enUS)) {
            return match
        }

        return Self.allCases.first {
            $0.rawValue.lowercased(with: .enUS) == lowercasedNeedle
        }
    }
}
