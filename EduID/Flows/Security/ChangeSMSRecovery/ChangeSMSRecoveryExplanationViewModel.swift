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
    
    /// The TIQR authentication challenge started via `startAuthenticationChallenge`. Its `identity` is
    /// resolved by the TIQR protocol itself (from the identity provider embedded in the challenge URL),
    /// so it is always correct - unlike matching `personalInfo.id` against locally stored identities.
    private var challenge: AuthenticationChallenge?
    
    /// Identifies the most recent `startAuthenticationChallenge` call, so callbacks of earlier (stale) requests can be ignored.
    private var currentChallengeRequestId = UUID()
    
    init(personalInfo: UserResponse) {
        self.personalInfo = personalInfo
    }
    
    private var identity: Identity? {
        challenge?.identity
    }
    
    /// Whether the user's identity can be verified using biometrics (Face ID / Touch ID) instead of a PIN code.
    /// Only meaningful after `startAuthenticationChallenge` has succeeded.
    var isBiometricVerificationAvailable: Bool {
        return identity?.biometricIDEnabled == 1 && ServiceContainer.sharedInstance().secretService.biometricIDAvailable
    }
    
    /// Starts a new TIQR authentication for the current user: asks the server for an authentication URL
    /// (which also establishes the `SESSION_KEY` the backend needs for the following phone re-verification
    /// calls), then parses that URL into a real `AuthenticationChallenge`, the same way scanning a QR code
    /// would. Must succeed before `verifyWithBiometrics`/`verifyWithPIN` can be used.
    @MainActor
    func startAuthenticationChallenge(completion: @escaping (Bool) -> Void) {
        let requestId = UUID()
        currentChallengeRequestId = requestId
        challenge = nil
        Task {
            do {
                let result = try await TiqrControllerAPI.startAuthenticationForSP()
                guard requestId == currentChallengeRequestId else { return }
                guard let url = result.url else {
                    NSLog("Could not start SMS recovery change authentication: no url in response")
                    completion(false)
                    return
                }
                ServiceContainer.sharedInstance().challengeService.startChallenge(fromScanResult: url) { [weak self] type, challengeObject, error in
                    guard let self, requestId == self.currentChallengeRequestId else { return }
                    guard type == .authentication, let challenge = challengeObject as? AuthenticationChallenge else {
                        NSLog("Could not start SMS recovery change authentication: \(error?.localizedDescription ?? "unknown error")")
                        completion(false)
                        return
                    }
                    self.challenge = challenge
                    completion(true)
                }
            } catch let ErrorResponse.error(statusCode, data, _, underlyingError) {
                guard requestId == currentChallengeRequestId else { return }
                let bodyString = data.flatMap { String(data: $0, encoding: .utf8) } ?? "<no body>"
                NSLog("Could not start SMS recovery change authentication: status=\(statusCode), body=\(bodyString), error=\(underlyingError)")
                completion(false)
            } catch {
                guard requestId == currentChallengeRequestId else { return }
                NSLog("Could not start SMS recovery change authentication: \(error)")
                completion(false)
            }
        }
    }
    
    /// Verifies the user's identity using biometrics (Face ID / Touch ID), completing the started
    /// authentication challenge server-side with the decrypted secret.
    func verifyWithBiometrics(completion: @escaping (Bool) -> Void) {
        guard let identity else {
            completion(false)
            return
        }
        ServiceContainer.sharedInstance().secretService.secret(for: identity, touchIDPrompt: L.PinAndBioMetrics.BiometricsPrompt.localization) { [weak self] data in
            guard let self, let data else {
                completion(false)
                return
            }
            self.completeChallenge(withSecret: data, completion: completion)
        } failureHandler: { _ in
            completion(false)
        }
    }
    
    /// Verifies the user's identity using the given PIN code, completing the started authentication
    /// challenge server-side with the decrypted secret. This is a real server round-trip (via the TIQR
    /// authentication-confirmation request), so - unlike a purely local check - it will actually reject
    /// an incorrect PIN.
    func verifyWithPIN(_ pin: String, completion: @escaping (Bool) -> Void) {
        guard let identity else {
            NSLog("Could not verify SMS recovery change: no identity on the current authentication challenge")
            completion(false)
            return
        }
        guard let secret = ServiceContainer.sharedInstance().secretService.secret(for: identity, withPIN: pin) else {
            completion(false)
            return
        }
        completeChallenge(withSecret: secret, completion: completion)
    }
    
    private func completeChallenge(withSecret secret: Data, completion: @escaping (Bool) -> Void) {
        guard let challenge else {
            completion(false)
            return
        }
        ServiceContainer.sharedInstance().challengeService.complete(challenge, withSecret: secret) { success, _, error in
            if !success {
                NSLog("Could not complete SMS recovery change authentication challenge: \(error.localizedDescription ?? "unknown error")")
            }
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
}
