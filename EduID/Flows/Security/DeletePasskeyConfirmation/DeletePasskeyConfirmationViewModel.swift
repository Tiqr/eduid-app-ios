//
//  DeletePasskeyConfirmationViewModel.swift
//  eduID
//
//  Created by Copilot on 2026. 09. 03..
//

import Foundation
import OpenAPIClient

class DeletePasskeyConfirmationViewModel {
    
    let personalInfo: UserResponse
    let passkey: PublicKeyCredentials
    
    init(personalInfo: UserResponse, passkey: PublicKeyCredentials) {
        self.personalInfo = personalInfo
        self.passkey = passkey
    }
    
    /// Removes the passkey by sending the credential to delete to the backend.
    @discardableResult
    func removePasskey() async throws -> UserResponse {
        return try await UserControllerAPI.updateCredentials(publicKeyCredentials: passkey)
    }
}
