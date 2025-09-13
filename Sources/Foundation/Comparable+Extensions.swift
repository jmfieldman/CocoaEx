//
//  Comparable+Extensions.swift
//  Copyright © 2025 Jason Fieldman.
//

import Foundation

/// A set of extensions to the `Comparable` protocol that provide clamping functionality.
public extension Comparable {
    /// Returns the receiver clamped to the given range.
    ///
    /// - Parameter range: The range to clamp the receiver to.
    /// - Returns: The receiver if it's within the range, otherwise the closest bound of the range.
    func clamped(by range: ClosedRange<Self>) -> Self {
        if self < range.lowerBound {
            range.lowerBound
        } else if self > range.upperBound {
            range.upperBound
        } else {
            self
        }
    }

    /// Returns the receiver clamped to a minimum value.
    ///
    /// - Parameter min: The minimum value to clamp the receiver to.
    /// - Returns: The receiver if it's greater than or equal to the minimum, otherwise the minimum.
    func clamped(min: Self) -> Self {
        self < min ? min : self
    }

    /// Returns the receiver clamped to a maximum value.
    ///
    /// - Parameter max: The maximum value to clamp the receiver to.
    /// - Returns: The receiver if it's less than or equal to the maximum, otherwise the maximum.
    func clamped(max: Self) -> Self {
        self > max ? max : self
    }
}
