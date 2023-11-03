//
//  Result+Utils.swift
//
//  Taken from: https://github.com/polypoly-eu/polyPod/blob/322030686c47f9bf4c85b17e286d9a3a98350873/platform/core/PolyPodCoreSwift/Sources/PolyPodCoreSwift/Extensions/Result+Utils.swift#L2
//
//  Original file license: GPL-3.0
//
//  Created by Dániel Zolnai on 2023. 06. 07..
//

import Foundation

extension Result {
    public func inspectError(_ inspect: (Error) -> Void) -> Self {
        if case let.failure(error) = self {
            inspect(error)
        }
        return self
    }
    
    public func unwrapOr(_ fallback: Success) -> Success {
        if let value = try? self.get() {
            return value
        }
        
        return fallback
    }
}
