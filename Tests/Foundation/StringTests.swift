//
//  StringTests.swift
//  Copyright © 2025 Jason Fieldman.
//

import CocoaEx
import Testing

@Suite("StringTests")
struct StringTests {
    @Test("iso8601Date parses valid ISO8601 date string")
    func validISO8601Date() {
        let dateString = "2023-12-25T10:30:00Z"
        let date = dateString.iso8601Date()
        #expect(date != nil)

        // Verify the date components
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: .gmt, from: date!)
        #expect(components.year == 2023)
        #expect(components.month == 12)
        #expect(components.day == 25)
        #expect(components.hour == 10)
        #expect(components.minute == 30)
        #expect(components.second == 0)
    }

    @Test("iso8601Date parses valid ISO8601 date string with timezone")
    func validISO8601DateWithTimezone() {
        let dateString = "2023-12-25T10:30:00-07:00"
        let date = dateString.iso8601Date()
        #expect(date != nil)

        // Verify the date components
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: .init(identifier: "PST")!, from: date!)
        #expect(components.year == 2023)
        #expect(components.month == 12)
        #expect(components.day == 25)
        #expect(components.hour == 9)
        #expect(components.minute == 30)
        #expect(components.second == 0)
    }

    @Test("iso8601Date returns nil for invalid date string")
    func invalidISO8601Date() {
        let invalidDateString = "not-a-date"
        let date = invalidDateString.iso8601Date()
        #expect(date == nil)
    }

    @Test("iso8601Date handles different ISO8601 formats")
    func differentISO8601Formats() {
        // Test with milliseconds
        let dateStringWithMillis = "2023-12-25T10:30:00.123Z"
        let dateWithMillis = dateStringWithMillis.iso8601Date()
        let calendar = Calendar.current
        let componentsWithMillis = calendar.dateComponents(in: .init(identifier: "PST")!, from: dateWithMillis!)
        #expect(dateWithMillis != nil)
        #expect(componentsWithMillis.year == 2023)

        // Test with timezone offset
        let dateStringWithOffset = "2023-12-25T10:30:00+05:00"
        let dateWithOffset = dateStringWithOffset.iso8601Date()
        let componentsWithOffset = calendar.dateComponents(in: .init(identifier: "PST")!, from: dateWithOffset!)
        #expect(dateWithOffset != nil)
        #expect(componentsWithOffset.year == 2023)

        // Test with milliseconds and offset
        let dateStringWithMillisOffset = "2023-12-25T10:30:00.123+05:00"
        let dateWithMillisOffset = dateStringWithMillisOffset.iso8601Date()
        let componentsWithMillisOffset = calendar.dateComponents(in: .init(identifier: "PST")!, from: dateWithMillisOffset!)
        #expect(dateWithMillis != nil)
        #expect(componentsWithMillisOffset.year == 2023)

        let dateStringWithDate = "2023-12-25"
        let dateWithDate = dateStringWithDate.iso8601Date()
        let componentsWithDate = calendar.dateComponents(in: .init(identifier: "PST")!, from: dateWithDate!)
        #expect(dateWithDate != nil)
        #expect(componentsWithDate.year == 2023)
    }

    @Test("iso8601Date handles empty string")
    func testEmptyString() {
        let emptyString = ""
        let date = emptyString.iso8601Date()
        #expect(date == nil)
    }
}
