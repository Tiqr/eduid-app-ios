//
//  PasswordResetLinkViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 16..
//

import Foundation
import OpenAPIClient

class PasswordResetLinkViewModel {
    
    let personalInfo: UserResponse
    
    init(personalInfo: UserResponse) {
        self.personalInfo = personalInfo
    }
    
    func generatePasswordCode() async throws -> UserResponse {
        return try await UserControllerAPI.generatePasswordCode()
    }
    
    func deletePassword(hash: String) async throws {
        _ = try await UserControllerAPI.resetPasswordHashValid(hash: hash)
    }
    
}
