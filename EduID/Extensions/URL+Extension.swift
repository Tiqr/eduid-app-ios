//
//  URL+Extension.swift
//  eduID
//
//  Created by Dániel Zolnai on 08/02/2024.
//

import Foundation

extension URL {
    // Returns the query parameters of an URL object. Source: https://stackoverflow.com/a/41421727/1395437
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
