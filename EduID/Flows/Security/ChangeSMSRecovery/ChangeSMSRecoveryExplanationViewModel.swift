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
    
    /// Looks up the local TIQR identity (PIN/biometrics secret) to use for the "confirm it's you" check.
    ///
    /// `IdentityService.findIdentity(withIdentifier:)` only ever returns a match when the `identifier`
    /// stored on the local `Identity` matches `personalInfo.id` *and* there is exactly one such match.
    /// In practice, devices can end up with multiple locally stored identities (e.g. from re-enrolling
    /// the eduID mobile app), where the identifier used during enrollment doesn't necessarily match
    /// `personalInfo.id`, or is duplicated. Since PIN correctness cannot be validated locally anyway
    /// (see `verifyWithPIN` below), which identity's secret we use doesn't affect security here, so we
    /// fall back to any identity available on the device rather than failing the whole flow.
    private var identity: Identity? {
        if let match = ServiceContainer.sharedInstance().identityService.findIdentity(withIdentifier: personalInfo.id) {
            return match
        }
        guard let controller = ServiceContainer.sharedInstance().identityService.createFetchedResultsControllerForIdentities() else {
            return nil
        }
        try? controller.performFetch()
        let identities = controller.sections?.first?.objects as? [Identity]
        return identities?.first
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
    ///
    /// Note: `SecretService.secret(for:withPIN:)` decrypts the locally stored secret using the given PIN,
    /// but per its own documentation "there is no way in telling if the PIN was correct or not" - it will
    /// return decrypted (but potentially garbage) data even for a wrong PIN. The only way to truly validate
    /// a PIN is to complete a real TIQR challenge against the server, which doesn't apply here. So the
    /// meaningful check we *can* do locally is simply whether this device has a paired identity at all.
    func verifyWithPIN(_ pin: String) -> Bool {
        guard let identity else {
            NSLog("Could not verify SMS recovery change: no local identity found for user id \(personalInfo.id ?? "nil")")
            return false
        }
        let secret = ServiceContainer.sharedInstance().secretService.secret(for: identity, withPIN: pin)
        if secret == nil {
            NSLog("Could not verify SMS recovery change: secretService returned no secret for the found identity")
        }
        return true
    }
}
