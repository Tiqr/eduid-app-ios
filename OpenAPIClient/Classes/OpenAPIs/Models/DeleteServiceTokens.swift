//
// DeleteServiceTokens.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct DeleteServiceTokens: Codable, JSONEncodable, Hashable {

    public var tokens: [TokenRepresentation]?

    public init(tokens: [TokenRepresentation]? = nil) {
        self.tokens = tokens
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case tokens
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(tokens, forKey: .tokens)
    }
}

