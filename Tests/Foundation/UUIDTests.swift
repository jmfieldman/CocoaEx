//
//  UUIDTests.swift
//  Copyright © 2025 Jason Fieldman.
//

import CocoaEx
import Testing

@Suite("UUIDTests")
struct UUIDTests {
    @Test func lowercasedUUIDString() {
        let uuid = UUID(uuidString: "edc9f322-42ad-471f-8b35-0f9c0e8e1a7e")!
        #expect(uuid.uppercaseUUIDString == "EDC9F322-42AD-471F-8B35-0F9C0E8E1A7E")
        #expect(uuid.lowercaseUUIDString == "edc9f322-42ad-471f-8b35-0f9c0e8e1a7e")
    }
}
