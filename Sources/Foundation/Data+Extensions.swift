//
//  Data+Extensions.swift
//  Copyright © 2025 Jason Fieldman.
//

import CryptoKit
import Foundation

public extension Data {
    /// Returns the SHA1 hash of the given data
    func sha1() -> Data {
        Data(Insecure.SHA1.hash(data: self))
    }

    /// Returns a hex-encoded representation of the data stream
    func hexEncoded() -> String {
        map { String(format: "%02hhx", $0) }.joined()
    }
}
