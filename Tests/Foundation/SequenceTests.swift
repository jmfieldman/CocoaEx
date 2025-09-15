//
//  SequenceTests.swift
//  Copyright © 2025 Jason Fieldman.
//

import CocoaEx
import Testing

@Suite("SequenceTests")
struct SequenceTests {
    @Test("mapToDictionary transforms sequence elements into dictionary")
    func mapToDictionaryTest() {
        let numbers = [1, 2, 3, 4, 5]

        // Test basic transformation
        let result = numbers.mapToDictionary { (number: Int) in
            (key: "num_\(number)", value: number * 2)
        }

        #expect(result["num_1"] == 2)
        #expect(result["num_2"] == 4)
        #expect(result["num_3"] == 6)
        #expect(result["num_4"] == 8)
        #expect(result["num_5"] == 10)
        #expect(result.count == 5)

        // Test with strings
        let words = ["apple", "banana", "cherry"]
        let wordLengths = words.mapToDictionary { (word: String) in
            (key: word, value: word.count)
        }

        #expect(wordLengths["apple"] == 5)
        #expect(wordLengths["banana"] == 6)
        #expect(wordLengths["cherry"] == 6)
        #expect(wordLengths.count == 3)
    }

    @Test("compactMapToDictionary transforms sequence elements into dictionary, filtering nil values")
    func compactMapToDictionaryTest() {
        let numbers = [1, 2, 3, 4, 5]

        // Test with some nil values
        let result = numbers.compactMapToDictionary { (number: Int) in
            if number % 2 == 0 {
                (key: "even_\(number)", value: number * 2)
            } else {
                nil
            }
        }

        #expect(result["even_2"] == 4)
        #expect(result["even_4"] == 8)
        #expect(result.count == 2)

        // Test with all nil values
        let allNilResult: [Int: Int] = numbers.compactMapToDictionary { (_: Int) in
            nil
        }

        #expect(allNilResult.isEmpty)

        // Test with all non-nil values
        let allValuesResult = numbers.compactMapToDictionary { (number: Int) in
            (key: "num_\(number)", value: number * 3)
        }

        #expect(allValuesResult["num_1"] == 3)
        #expect(allValuesResult["num_2"] == 6)
        #expect(allValuesResult["num_3"] == 9)
        #expect(allValuesResult["num_4"] == 12)
        #expect(allValuesResult["num_5"] == 15)
        #expect(allValuesResult.count == 5)
    }

    @Test("mapToDictionary handles errors properly")
    func mapToDictionaryErrorHandling() {
        let numbers = [1, 2, 3]

        // Test error handling
        #expect(throws: NSError(domain: "TestError", code: 1, userInfo: nil)) { () in
            _ = try numbers.mapToDictionary { (number: Int) in
                if number == 2 {
                    throw NSError(domain: "TestError", code: 1, userInfo: nil)
                }
                return (key: "num_\(number)", value: number)
            }
        }
    }

    @Test("compactMapToDictionary handles errors properly")
    func compactMapToDictionaryErrorHandling() {
        let numbers = [1, 2, 3]

        // Test error handling
        #expect(throws: NSError(domain: "TestError", code: 1, userInfo: nil)) { () in
            _ = try numbers.compactMapToDictionary { (number: Int) in
                if number == 2 {
                    throw NSError(domain: "TestError", code: 1, userInfo: nil)
                }
                return (key: "num_\(number)", value: number)
            }
        }
    }
}
