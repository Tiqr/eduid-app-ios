//
// StartAuthentication.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct StartAuthentication: Codable, JSONEncodable, Hashable {

    public var sessionKey: String?
    public var url: String?
    public var qr: String?
    public var tiqrCookiePresent: Bool?

    public init(sessionKey: String? = nil, url: String? = nil, qr: String? = nil, tiqrCookiePresent: Bool? = nil) {
        self.sessionKey = sessionKey
        self.url = url
        self.qr = qr
        self.tiqrCookiePresent = tiqrCookiePresent
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case sessionKey
        case url
        case qr
        case tiqrCookiePresent
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sessionKey, forKey: .sessionKey)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(qr, forKey: .qr)
        try container.encodeIfPresent(tiqrCookiePresent, forKey: .tiqrCookiePresent)
    }
}

