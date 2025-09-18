//
//  DictionaryTests.swift
//  Copyright © 2025 Jason Fieldman.
//

import CocoaEx
import Testing

@Suite("DictionaryTests")
struct DictionaryTests {
    @Test("with function adds optional values to dictionary")
    func withFunctionTest() {
        // Test basic functionality
        let initialDict = ["existing": "value"]

        let result = initialDict.with { dict in
            dict["newKey"] = "newValue"
        }

        #expect(result["existing"] == "value")
        #expect(result["newKey"] == "newValue")
        #expect(result.count == 2)
    }

    @Test("with function handles nil optional values")
    func withFunctionWithNilValuesTest() {
        // Test with nil values
        let initialDict = ["existing": "value"]

        let result = initialDict.with { dict in
            dict["optionalKey"] = nil
        }

        #expect(result["existing"] == "value")
        #expect(result["optionalKey"] == nil)
        #expect(result.count == 1)
    }

    @Test("with function modifies dictionary in place without affecting original")
    func withFunctionDoesNotModifyOriginalTest() {
        // Test that the original dictionary is not modified
        let initialDict = ["existing": "value"]
        let originalDict = initialDict

        let result = initialDict.with { dict in
            dict["newKey"] = "newValue"
        }

        #expect(initialDict["existing"] == "value")
        #expect(initialDict["newKey"] == nil)
        #expect(initialDict.count == 1)

        #expect(result["existing"] == "value")
        #expect(result["newKey"] == "newValue")
        #expect(result.count == 2)

        #expect(originalDict["existing"] == "value")
        #expect(originalDict.count == 1)
    }

    @Test("with function works with empty dictionary")
    func withFunctionWithEmptyDictionaryTest() {
        // Test with empty dictionary
        let initialDict: [String: String] = [:]

        let result = initialDict.with { dict in
            dict["key"] = "value"
        }

        #expect(result["key"] == "value")
        #expect(result.count == 1)
    }

    @Test("with function handles multiple modifications")
    func withFunctionMultipleModificationsTest() {
        // Test multiple modifications
        let initialDict = ["existing": "value"]

        let result = initialDict.with { dict in
            dict["newKey1"] = "newValue1"
            dict["newKey2"] = "newValue2"
            dict["existing"] = "modifiedValue"
        }

        #expect(result["existing"] == "modifiedValue")
        #expect(result["newKey1"] == "newValue1")
        #expect(result["newKey2"] == "newValue2")
        #expect(result.count == 3)
    }
}
