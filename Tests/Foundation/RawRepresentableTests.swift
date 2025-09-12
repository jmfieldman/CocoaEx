//
//  RawRepresentableTests.swift
//  Copyright © 2025 Jason Fieldman.
//

import CocoaEx
import Testing

private enum IntEnum: Int {
    case one = 1
    case two = 2
}

private enum StringEnum: String, CaseIterable {
    case one = "one"
    case two = "tWo"
    case ten = "TEN"
}

@Suite("RawRepresentableTests")
struct RawRepresentableTests {
    @Test func optional() {
        let optionalIntOne: Int? = 1
        let optionalIntNone: Int? = nil

        #expect(IntEnum(optionalRawValue: optionalIntNone) == nil)
        #expect(IntEnum.one == IntEnum(optionalRawValue: optionalIntOne))
        #expect(IntEnum.two == IntEnum(optionalRawValue: 2))
    }

    @Test func caseInsensitive() {
        #expect(StringEnum.one == StringEnum(rawValue: "one"))
        #expect(StringEnum.one == StringEnum.caseInsensitive(matching: "one"))
        #expect(StringEnum.one == StringEnum.caseInsensitive(matching: "oNe"))
        #expect(StringEnum.two == StringEnum.caseInsensitive(matching: "two"))
        #expect(StringEnum.two == StringEnum.caseInsensitive(matching: "twO"))
        #expect(StringEnum.ten == StringEnum.caseInsensitive(matching: "ten"))
        #expect(StringEnum.caseInsensitive(matching: "nine") == nil)
    }
}
