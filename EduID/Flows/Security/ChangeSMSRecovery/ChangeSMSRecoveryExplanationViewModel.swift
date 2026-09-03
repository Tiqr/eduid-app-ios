//
//  ChangeSMSRecoveryExplanationViewModel.swift
//  eduID
//
//  Created by Copilot on 2026. 09. 03..
//

import Foundation
import OpenAPIClient
import TiqrCoreObjC

class ChangeSMSRecoveryExplanationViewModel {
    
    let personalInfo: UserResponse
    
    init(personalInfo: UserResponse) {
        self.personalInfo = personalInfo
    }
    
    private var identity: Identity? {
        ServiceContainer.sharedInstance().identityService.findIdentity(withIdentifier: personalInfo.id)
    }
    
    /// Whether the user's identity can be verified using biometrics (Face ID / Touch ID) instead of a PIN code.
    var isBiometricVerificationAvailable: Bool {
        return identity?.biometricIDEnabled == 1 && ServiceContainer.sharedInstance().secretService.biometricIDAvailable
    }
    
    /// Verifies the user's identity using biometrics (Face ID / Touch ID).
    func verifyWithBiometrics(completion: @escaping (Bool) -> Void) {
        guard let identity else {
            completion(false)
            return
        }
        ServiceContainer.sharedInstance().secretService.secret(for: identity, touchIDPrompt: L.PinAndBioMetrics.BiometricsPrompt.localization) { data in
            completion(data != nil)
        } failureHandler: { _ in
            completion(false)
        }
    }
    
    /// Verifies the user's identity using the given PIN code.
    func verifyWithPIN(_ pin: String) -> Bool {
        guard let identity else { return false }
        let secret = ServiceContainer.sharedInstance().secretService.secret(for: identity, withPIN: pin)
        return secret != nil
    }
}
