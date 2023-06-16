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
    
    func requestPasswordResetLink() async throws -> UserResponse {
        return try await UserControllerAPI.resetPasswordLink()
    }
    
}
