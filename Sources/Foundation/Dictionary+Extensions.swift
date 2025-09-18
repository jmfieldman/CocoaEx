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
}
