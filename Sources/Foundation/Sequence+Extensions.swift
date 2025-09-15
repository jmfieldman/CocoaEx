//
//  Sequence+Extensions.swift
//  Copyright © 2025 Jason Fieldman.
//

import Foundation

public extension Sequence {
    /// Creates a dictionary by transforming each element of the sequence into a key-value pair.
    ///
    /// - Parameter transform: A closure that takes an element and returns a tuple of (key, value).
    /// - Returns: A dictionary with keys and values derived from the sequence elements.
    /// - Throws: Any error thrown by the transform closure.
    func mapToDictionary<Key: Hashable, Value>(_ transform: (Iterator.Element) throws -> (key: Key, value: Value)) rethrows -> [Key: Value] {
        try reduce(into: [Key: Value]()) { partialResult, element in
            let mapping = try transform(element)
            partialResult[mapping.key] = mapping.value
        }
    }

    /// Creates a dictionary by transforming each element of the sequence into a key-value pair, filtering out nil values.
    ///
    /// - Parameter transform: A closure that takes an element and returns an optional tuple of (key, value).
    /// - Returns: A dictionary with keys and values derived from the sequence elements, excluding nil values.
    /// - Throws: Any error thrown by the transform closure.
    func compactMapToDictionary<Key: Hashable, Value>(_ transform: (Iterator.Element) throws -> (key: Key, value: Value)?) rethrows -> [Key: Value] {
        try reduce(into: [Key: Value]()) { partialResult, element in
            if let mapping = try transform(element) {
                partialResult[mapping.key] = mapping.value
            }
        }
    }
}
