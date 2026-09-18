//
//  RemoveMobileAppConfirmationViewModel.swift
//  eduID
//
//  Created by Copilot on 2026. 09. 18..
//

import Foundation
import OpenAPIClient

class RemoveMobileAppConfirmationViewModel {
    
    let personalInfo: UserResponse
    
    init(personalInfo: UserResponse) {
        self.personalInfo = personalInfo
    }
    
    /// Requests a de-activation code to be sent via SMS. Entering this code correctly (on the following
    /// screen) is what actually removes the eduID mobile app as a login method server-side.
    func sendDeactivationCode() async throws {
        _ = try await TiqrControllerAPI.sendDeactivationPhoneCodeForSp()
    }
}
