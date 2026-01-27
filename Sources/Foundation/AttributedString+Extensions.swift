//
//  AttributedString+Extensions.swift
//  Copyright © 2026 Jason Fieldman.
//

import Foundation
import SwiftUI

// MARK: - Public API

public enum AttributedMarkdown {
    public struct Options: Sendable {
        public var spacesPerIndent: Int = 2
        public var underlineAsHTML: Bool = true

        /// If true, ordered lists increment numbers (1., 2., 3.). If false, always uses "1.".
        public var incrementOrderedLists: Bool = true

        public init() {}
    }

    public static func encode(_ attributed: AttributedString, options: Options = .init()) -> String {
        var enc = MarkdownEncoder(options: options)
        return enc.encode(attributed)
    }
}

public extension AttributedString {
    func toMarkdown(options: AttributedMarkdown.Options = .init()) -> String {
        AttributedMarkdown.encode(self, options: options)
    }
}

// MARK: - Encoder

private struct MarkdownEncoder {
    let options: AttributedMarkdown.Options

    /// Ordered list counters keyed by list container id (plus nesting path if you extend it).
    private var orderedCounters: [String: Int] = [:]

    init(options: AttributedMarkdown.Options) {
        self.options = options
    }

    mutating func encode(_ attributed: AttributedString) -> String {
        // 1) Split into paragraph-atoms (by paragraph identity)
        let atoms = splitIntoParagraphAtoms(attributed)

        // 2) Merge consecutive list atoms that share the same list container id
        let blocks = mergeAtomsIntoBlocks(atoms)

        // 3) Emit blocks with correct spacing rules
        return render(blocks)
    }

    // MARK: - Paragraph atoms

    private struct Atom {
        var intent: PresentationIntent?
        var content: AttributedString

        // Derived:
        var listInfo: ListInfo?
        var headerLevel: Int?
        var indentLevels: Int
    }

    private struct ListInfo: Equatable {
        enum Kind { case unordered, ordered }
        var kind: Kind
        /// Identity of the list container (e.g. "4" in unorderedList (id 4))
        var containerID: String
        /// Best-effort nesting depth (unorderedList nesting + indented levels)
        var depth: Int
    }

    private mutating func splitIntoParagraphAtoms(_ attributed: AttributedString) -> [Atom] {
        var atoms: [Atom] = []

        var currentKey: String? = nil
        var currentIntent: PresentationIntent? = nil
        var buffer = AttributedString()

        for run in attributed.runs {
            let piece = attributed[run.range]
            let intent = run.presentationIntent
            let key = paragraphIdentityKey(intent)

            if currentKey == nil {
                currentKey = key
                currentIntent = intent
            } else if key != currentKey {
                atoms.append(makeAtom(intent: currentIntent, content: buffer))
                buffer = AttributedString()
                currentKey = key
                currentIntent = intent
            }

            buffer.append(piece)
        }

        atoms.append(makeAtom(intent: currentIntent, content: buffer))
        return atoms
    }

    private func makeAtom(intent: PresentationIntent?, content: AttributedString) -> Atom {
        let parsed = parsePresentationIntent(intent)
        return Atom(
            intent: intent,
            content: content,
            listInfo: parsed.listInfo,
            headerLevel: parsed.headerLevel,
            indentLevels: parsed.indentLevels
        )
    }

    /// Key used ONLY for grouping runs into paragraph atoms.
    /// For AttributedString(markdown:), paragraph boundaries exist structurally; identity is often present.
    private func paragraphIdentityKey(_ intent: PresentationIntent?) -> String {
        guard let intent else { return "nil" }
        // Prefer a stable identity if present; fall back to full description.
        if let id = extractIdentity(from: intent) { return "p:\(id)" }
        return "pdesc:\(String(describing: intent))"
    }

    // MARK: - Blocks (lists vs non-lists)

    private enum Block {
        case list(kind: ListInfo.Kind, containerID: String, items: [Atom])
        case para(Atom)
    }

    private func mergeAtomsIntoBlocks(_ atoms: [Atom]) -> [Block] {
        var blocks: [Block] = []
        blocks.reserveCapacity(atoms.count)

        var i = 0
        while i < atoms.count {
            let a = atoms[i]

            if let li = a.listInfo {
                // Start a list block and collect consecutive atoms with same containerID and kind
                var items: [Atom] = [a]
                var j = i + 1
                while j < atoms.count, let nextLI = atoms[j].listInfo,
                      nextLI.kind == li.kind, nextLI.containerID == li.containerID
                {
                    items.append(atoms[j])
                    j += 1
                }

                blocks.append(.list(kind: li.kind, containerID: li.containerID, items: items))
                i = j
            } else {
                blocks.append(.para(a))
                i += 1
            }
        }

        return blocks
    }

    // MARK: - Rendering

    private mutating func render(_ blocks: [Block]) -> String {
        var outLines: [String] = []

        func ensureBlankLineIfNeeded() {
            // Add a blank line only if last line exists and isn’t already blank.
            if let last = outLines.last, !last.isEmpty {
                outLines.append("")
            }
        }

        for (idx, block) in blocks.enumerated() {
            switch block {
            case let .para(atom):
                if idx > 0 {
                    // Separate paragraphs/blocks by a blank line.
                    ensureBlankLineIfNeeded()
                }
                outLines.append(renderParagraphAtom(atom))

            case let .list(kind, containerID, items):
                if idx > 0 {
                    // Blank line before a list if previous block was not already separated.
                    ensureBlankLineIfNeeded()
                }

                // Reset numbering per list container.
                if kind == .ordered {
                    orderedCounters[containerID] = 0
                }

                for item in items {
                    outLines.append(renderListItemAtom(item, listKind: kind, containerID: containerID))
                }
                // After list, next paragraph block will add blank line via ensureBlankLineIfNeeded()
            }
        }

        return outLines.joined(separator: "\n")
    }

    private func renderParagraphAtom(_ atom: Atom) -> String {
        let inline = encodeInline(atom.content)

        if let level = atom.headerLevel {
            let hashes = String(repeating: "#", count: max(1, min(6, level)))
            return inline.isEmpty ? "" : "\(hashes) \(inline)"
        }

        if atom.indentLevels > 0 {
            let indent = String(repeating: " ", count: atom.indentLevels * options.spacesPerIndent)
            return "\(indent)\(inline)"
        }

        return inline
    }

    private mutating func renderListItemAtom(_ atom: Atom, listKind: ListInfo.Kind, containerID: String) -> String {
        let inline = encodeInline(atom.content)
        let depth = atom.listInfo?.depth ?? 0
        let indent = String(repeating: " ", count: depth * options.spacesPerIndent)

        switch listKind {
        case .unordered:
            return "\(indent)- \(inline)"
        case .ordered:
            let n: Int
            if options.incrementOrderedLists {
                let next = (orderedCounters[containerID] ?? 0) + 1
                orderedCounters[containerID] = next
                n = next
            } else {
                n = 1
            }
            return "\(indent)\(n). \(inline)"
        }
    }

    // MARK: - Intent parsing

    private struct ParsedIntent {
        var headerLevel: Int?
        var listInfo: ListInfo?
        var indentLevels: Int
    }

    private func parsePresentationIntent(_ intent: PresentationIntent?) -> ParsedIntent {
        guard let intent else { return .init(headerLevel: nil, listInfo: nil, indentLevels: 0) }

        var headerLevel: Int? = nil
        var indentLevels = 0

        var listKind: ListInfo.Kind? = nil
        var listContainerID: String? = nil
        var listDepth = 0
        var isListItem = false

        for comp in intent.components {
            switch comp.kind {
            case let .header(level):
                headerLevel = level

            case .unorderedList:
                listKind = .unordered
                listDepth += 1

            case .orderedList:
                listKind = .ordered
                listDepth += 1

            case .listItem:
                isListItem = true

            default:
                break
            }
        }

        let listInfo: ListInfo?
        if isListItem, let kind = listKind {
            let containerID = (extractIdentity(from: intent) ?? String(describing: intent)) + "|" + (kind == .ordered ? "ol" : "ul")

            // Depth: outer list container shouldn’t indent the first level.
            let depth = max(0, (listDepth - 1) + indentLevels)
            listInfo = .init(kind: kind, containerID: containerID, depth: depth)
        } else {
            listInfo = nil
        }

        return .init(headerLevel: headerLevel, listInfo: listInfo, indentLevels: indentLevels)
    }

    // MARK: - Identity extraction

    /// Extract PresentationIntent.identity if available (most SDKs), else nil.
    private func extractIdentity(from intent: PresentationIntent) -> String? {
        // Prefer direct identity if the SDK exposes it.
        // If not, use Mirror as a compatibility fallback.
        let m = Mirror(reflecting: intent)
        for child in m.children {
            if child.label == "identity" {
                return String(describing: child.value)
            }
        }
        return nil
    }

    // MARK: - Inline encoding

    private struct InlineStyle: Equatable {
        var bold = false
        var italic = false
        var underline = false
    }

    private func encodeInline(_ attributed: AttributedString) -> String {
        var out = ""
        var current = InlineStyle()

        func open(_ s: InlineStyle) -> String {
            var r = ""
            if s.underline, options.underlineAsHTML { r += "<u>" }
            if s.bold { r += "**" }
            if s.italic { r += "*" }
            return r
        }

        func close(_ s: InlineStyle) -> String {
            var r = ""
            if s.italic { r += "*" }
            if s.bold { r += "**" }
            if s.underline, options.underlineAsHTML { r += "</u>" }
            return r
        }

        for run in attributed.runs {
            let target = style(for: run)

            if target != current {
                out += close(current)
                out += open(target)
                current = target
            }

            let chunk = String(attributed[run.range].characters)
            out += escapeMarkdown(chunk)
        }

        out += close(current)
        return out
    }

    private func style(for run: AttributedString.Runs.Run) -> InlineStyle {
        var s = InlineStyle()

        if let intent = run.inlinePresentationIntent {
            if intent.contains(.stronglyEmphasized) { s.bold = true }
            if intent.contains(.emphasized) { s.italic = true }
        }

        if options.underlineAsHTML {
            if let u = run.underlineStyle, u != Text.LineStyle() {
                s.underline = true
            }
        }

        return s
    }

    // MARK: - Escaping

    private func escapeMarkdown(_ text: String) -> String {
        var out = ""
        out.reserveCapacity(text.count)

        for ch in text {
            switch ch {
            case "\\", "`", "*", "_", "{", "}", "[", "]", "(", ")", "#", "+", "-", "!", "|", ">":
                out.append("\\")
                out.append(ch)
            default:
                out.append(ch)
            }
        }

        return out
    }
}
