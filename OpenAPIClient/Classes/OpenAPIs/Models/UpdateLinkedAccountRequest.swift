//
// UpdateLinkedAccountRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct UpdateLinkedAccountRequest: Codable, JSONEncodable, Hashable {

    public var eduPersonPrincipalName: String?
    public var subjectId: String?
    public var external: Bool?
    public var idpScoping: String?

    public init(eduPersonPrincipalName: String? = nil, subjectId: String? = nil, external: Bool? = nil, idpScoping: String? = nil) {
        self.eduPersonPrincipalName = eduPersonPrincipalName
        self.subjectId = subjectId
        self.external = external
        self.idpScoping = idpScoping
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case eduPersonPrincipalName
        case subjectId
        case external
        case idpScoping
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(eduPersonPrincipalName, forKey: .eduPersonPrincipalName)
        try container.encodeIfPresent(subjectId, forKey: .subjectId)
        try container.encodeIfPresent(external, forKey: .external)
        try container.encodeIfPresent(idpScoping, forKey: .idpScoping)
    }
}

