//
//  PasswordCreationViewModel.swift
//  eduID
//
//  Created by Yasser Farahi on 22/08/2025.
//

import Foundation
import OpenAPIClient

final class PasswordCreationViewModel {
    
    var hash: String
    
    public var successClosure: (() -> Void)?
    public var requesting: Bool = false
    public var errorClosure: ((String, String) -> Void)?
    
    init(hash: String) {
        self.hash = hash
    }
    
    public func createPassword(with value: String?) async {
        guard let password = value else { return }
        do {
            guard !requesting else { return }
            requesting = true
            _ = try await UserControllerAPI.updateUserPassword(updateUserSecurityRequest: .init(newPassword: password, hash: hash))
            successClosure?()
        } catch {
            errorClosure?(error.localizedFromApi, error.localizedDescription)
        }
    }
    
}
