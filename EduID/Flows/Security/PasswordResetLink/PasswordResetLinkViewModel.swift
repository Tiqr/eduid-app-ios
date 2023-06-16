//
//  PasswordResetLinkViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 16..
//

import Foundation
import OpenAPIClient

class PasswordResetLinkViewModel {
    
    func requestPasswordResetLink() async throws -> UserResponse {
        return try await UserControllerAPI.resetPasswordLink()
    }
    
}
