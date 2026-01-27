//
//  AttributedStringTests.swift
//  Copyright © 2025 Jason Fieldman.
//

import CocoaEx
import Testing

@Suite("AttributedStringTests")
struct AttributedStringTests {
    @Test("markdown conversion works")
    func markdownConversionWorks() {
        var mdString = """
        This is normal text.
        """

        var attributedString = try! AttributedString(markdown: mdString)
        var mdExtract = attributedString.toMarkdown()
        #expect(mdExtract == mdString)

        mdString = """
        This is **bold** text.
        """
        attributedString = try! AttributedString(markdown: mdString)
        mdExtract = attributedString.toMarkdown()
        #expect(mdExtract == mdString)

        mdString = """
        This is *italic* text.
        """
        attributedString = try! AttributedString(markdown: mdString)
        mdExtract = attributedString.toMarkdown()
        #expect(mdExtract == mdString)

        mdString =
            """
            This text is normal.

            ## This is heading 2.

            #### this is heading 4.

            normal again.
            """
        attributedString = try! AttributedString(markdown: mdString)
        mdExtract = attributedString.toMarkdown()
        #expect(mdExtract == mdString)

        mdString =
            """
            This text is normal.

            ## 1. This is heading 2.

            #### 2. this is heading 4.

            normal again.
            """
        attributedString = try! AttributedString(markdown: mdString)
        mdExtract = attributedString.toMarkdown()
        #expect(mdExtract == mdString)
    }
}
