//
// EduIDValue.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct EduIDValue: Codable, JSONEncodable, Hashable {

    /** New assigned eduID scoped on external remote API user */
    public var value: String?

    public init(value: String? = nil) {
        self.value = value
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case value
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(value, forKey: .value)
    }
}

