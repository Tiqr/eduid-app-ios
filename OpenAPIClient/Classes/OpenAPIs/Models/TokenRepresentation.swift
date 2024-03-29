//
// TokenRepresentation.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct TokenRepresentation: Codable, JSONEncodable, Hashable {

    public enum ModelType: String, Codable, CaseIterable {
        case access = "ACCESS"
        case refresh = "REFRESH"
    }
    public var id: String?
    public var type: ModelType?

    public init(id: String? = nil, type: ModelType? = nil) {
        self.id = id
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case type
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }
}

