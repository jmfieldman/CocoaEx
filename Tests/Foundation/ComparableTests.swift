//
//  ComparableTests.swift
//  Copyright © 2025 Jason Fieldman.
//

import CocoaEx
import Testing

@Suite("ComparableTests")
struct ComparableTests {
    @Test("Clamped by range - within bounds")
    func clampedByRangeWithinBounds() {
        let value = 5
        let range = 1 ... 10
        let result = value.clamped(by: range)
        #expect(result == 5)
    }

    @Test("Clamped by range - below lower bound")
    func clampedByRangeBelowLowerBound() {
        let value = 0
        let range = 1 ... 10
        let result = value.clamped(by: range)
        #expect(result == 1)
    }

    @Test("Clamped by range - above upper bound")
    func clampedByRangeAboveUpperBound() {
        let value = 15
        let range = 1 ... 10
        let result = value.clamped(by: range)
        #expect(result == 10)
    }

    @Test("Clamped by range - at lower bound")
    func clampedByRangeAtLowerBound() {
        let value = 1
        let range = 1 ... 10
        let result = value.clamped(by: range)
        #expect(result == 1)
    }

    @Test("Clamped by range - at upper bound")
    func clampedByRangeAtUpperBound() {
        let value = 10
        let range = 1 ... 10
        let result = value.clamped(by: range)
        #expect(result == 10)
    }

    @Test("Clamped min - above minimum")
    func clampedMinAboveMinimum() {
        let value = 5
        let min = 1
        let result = value.clamped(min: min)
        #expect(result == 5)
    }

    @Test("Clamped min - below minimum")
    func clampedMinBelowMinimum() {
        let value = 0
        let min = 1
        let result = value.clamped(min: min)
        #expect(result == 1)
    }

    @Test("Clamped min - at minimum")
    func clampedMinAtMinimum() {
        let value = 1
        let min = 1
        let result = value.clamped(min: min)
        #expect(result == 1)
    }

    @Test("Clamped max - below maximum")
    func clampedMaxBelowMaximum() {
        let value = 5
        let max = 10
        let result = value.clamped(max: max)
        #expect(result == 5)
    }

    @Test("Clamped max - above maximum")
    func clampedMaxAboveMaximum() {
        let value = 15
        let max = 10
        let result = value.clamped(max: max)
        #expect(result == 10)
    }

    @Test("Clamped max - at maximum")
    func clampedMaxAtMaximum() {
        let value = 10
        let max = 10
        let result = value.clamped(max: max)
        #expect(result == 10)
    }
}
