//
//  KeyChainService.swift
//  
//
//  Created by Yasser Farahi on 17/04/2023.
//

import Foundation
import KeychainSwift
import AppAuth

public class KeyChainService {
    
    private let keychain = KeychainSwift(keyPrefix: Constants.KeyChain.keyPrefix)
    
    public init() {}
    
    public func set(_ value: String, for key: String) {
        keychain.set(value, forKey: key, withAccess: .accessibleAfterFirstUnlock)
    }
    
    public func setData(_ data: Data, for key: String) {
        keychain.set(data, forKey: key)
    }
    
    public func set(_ value: Bool, for key: String) {
        keychain.set(value, forKey: key)
    }
    
    public func getBool(for key: String) -> Bool {
        return keychain.getBool(key) ?? false
    }
    
    public func getString(for key: String) -> String? {
        return keychain.get(key)
    }
    
    public func getData(for key: String) -> Data? {
        return keychain.getData(key) ?? nil
    }
    
    public func delete(for key: String) {
       keychain.delete(key)
    }
}

