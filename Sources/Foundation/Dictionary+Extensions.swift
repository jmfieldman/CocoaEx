//
//  Dictionary+Extensions.swift
//  Copyright © 2025 Jason Fieldman.
//

import Foundation

public extension Dictionary {
    /// Allows you to include optional values in a Dictionary literal
    /// example:
    ///
    ///   let dict = [
    ///       "Value1": value1
    ///   ].with {
    ///       $0["OptionalValue2"] = optionalValue2
    ///   }
    func with(modifications: (inout [Key: Value]) -> Void) -> [Key: Value] {
        var copied = self
        modifications(&copied)
        return copied
    }

    /// Maps the dictionary to an array based on the specific provided key
    /// order. Entries in the dictionary not represented in the keyOrder will
    /// not be present in the result. Can be used in conjunction with
    /// `mapToGroupedDictionary` to convert an array of random elements into
    /// a deterministically-ordered array of sections.
    func compactMapWithKeyOrder<T>(
        _ keyOrder: [Key],
        _ transform: (Key, Value) throws -> T?
    ) rethrows -> [T] {
        try keyOrder.compactMap { key in
            guard let value = self[key] else { return nil }
            return try transform(key, value)
        }
    }
}
