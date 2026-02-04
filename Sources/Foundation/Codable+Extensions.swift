//
//  Codable+Extensions.swift
//  Copyright © 2026 Jason Fieldman.
//

public extension Decodable {
    func from(jsonString string: String) throws -> Self? {
        try string.data(using: .utf8).flatMap { try from(jsonData: $0) }
    }

    func from(jsonData data: Data) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}

public extension Encodable {
    func toJsonData() throws -> Data {
        try JSONEncoder().encode(self)
    }

    func toJsonString() throws -> String? {
        let data = try toJsonData()
        return String(data: data, encoding: .utf8)
    }
}
