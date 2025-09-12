//
//  RawRepresentable+Extensions.swift
//  Copyright © 2025 Jason Fieldman.
//

import Foundation

public extension RawRepresentable {
    init?(optionalRawValue: RawValue?) {
        guard let optionalRawValue else {
            return nil
        }
        self.init(rawValue: optionalRawValue)
    }
}

public extension RawRepresentable where RawValue == String, Self: CaseIterable {
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
