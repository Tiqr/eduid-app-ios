//
//  OIDTokenStorage.swift
//
//  Taken from: https://github.com/polypoly-eu/polyPod/blob/322030686c47f9bf4c85b17e286d9a3a98350873/platform/ios/PolyPodApp/OIDAuth/OIDTokenStorage.swift#L4
//
//  Original license: GPL-3.0
//
//  Created by Dániel Zolnai on 2023. 06. 07..
//

import Foundation

import AppAuth
import Security

enum OIDTokenStorage {
    
    private static let tokenStorageService = "nl.eduid.app.tokenstorage-service"
    
    enum Error: Swift.Error {
        case keychainAccessFailed(OSStatus)
        case failedToSetAuthState(OSStatus)
        case failedToReadAuthState(OSStatus)
        case failedToDeleteAuthState(OSStatus)
    }

    static func storeAuthState(_ authState: OIDAuthState, forService service: String) -> Result<Void, Swift.Error> {
        Result {
            let encodedState = try authState.encode()
            if try containsAuthState(forService: service) {
                let query: [CFString: Any] = [
                    kSecAttrAccount: service,
                    kSecAttrService: tokenStorageService,
                    kSecClass: kSecClassGenericPassword
                ]
                
                let attributesToUpdate = [kSecValueData: encodedState] as CFDictionary
                return SecItemUpdate(query as CFDictionary, attributesToUpdate)
            } else {
                let query = [
                    kSecValueData: encodedState,
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrAccount: service,
                    kSecAttrService: tokenStorageService,
                ] as CFDictionary
                return SecItemAdd(query, nil)
            }
        }.flatMap { status in
            if status == errSecSuccess {
                return .success(())
            }
            return .failure(Error.failedToSetAuthState(status))
        }
    }

    static func getAuthState(forService service: String) -> Result<OIDAuthState?, Swift.Error> {
        Result {
            let query = [kSecAttrAccount: service,
                         kSecAttrService: tokenStorageService,
                               kSecClass: kSecClassGenericPassword,
                          kSecReturnData: true] as [CFString: Any]
            
            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            guard status == errSecSuccess else {
                throw Error.failedToReadAuthState(status)
            }
            return try (result as? Data).map(OIDAuthState.decoded(from:))
        }
    }

    static func removeAuthState(forService service: String) -> Result<Void, Swift.Error> {
        Result {
            let query = [
                kSecAttrAccount: service,
                kSecAttrService: tokenStorageService,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            let status = SecItemDelete(query)
            guard status == errSecSuccess else {
                throw Error.failedToDeleteAuthState(status)
            }
        }
    }

    static func containsAuthState(forService service: String) throws -> Bool {
        let query = [
            kSecAttrAccount: service,
            kSecAttrService: tokenStorageService,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        let status = SecItemCopyMatching(query, nil)
        switch status {
        case errSecSuccess, errSecInteractionNotAllowed:
            return true
        case errSecItemNotFound:
            return false
        default:
            throw Error.keychainAccessFailed(status)
        }
    }
}

extension OIDAuthState {
    struct DecodedNilResponse: Error {}
    
    func encode() throws -> Data {
        try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
    }
    
    static func decoded(from data: Data) throws -> OIDAuthState {
        guard let decoded = try NSKeyedUnarchiver.unarchivedObject(
            ofClass: OIDAuthState.self,
            from: data
        ) else {
            throw DecodedNilResponse()
        }
        return decoded
    }
}
