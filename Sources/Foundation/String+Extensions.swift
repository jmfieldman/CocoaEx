//
//  String+Extensions.swift
//  Copyright © 2025 Jason Fieldman.
//

import Foundation

private let iso8601_Converter_Date = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate]
    return formatter
}()

private let iso8601_Converter_Time = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate, .withFullTime]
    return formatter
}()

private let iso8601_Converter_TimeMsec = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate, .withFractionalSeconds, .withFullTime]
    return formatter
}()

public extension String {
    func iso8601Date() -> Date? {
        if contains(".") {
            iso8601_Converter_TimeMsec.date(from: self)
        } else if count == 10 {
            iso8601_Converter_Date.date(from: self)
        } else {
            iso8601_Converter_Time.date(from: self)
        }
    }
}
