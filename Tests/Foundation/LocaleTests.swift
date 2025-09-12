//
//  LocaleTests.swift
//  Copyright © 2025 Jason Fieldman.
//

import CocoaEx
import Testing

@Suite("LocaleTests")
struct LocaleTests {
    @Test func enUs() {
        #expect(Locale.enUS == Locale(identifier: "en_US"))
    }
}
