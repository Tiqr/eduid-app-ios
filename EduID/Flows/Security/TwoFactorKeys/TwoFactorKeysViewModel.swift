//
//  TwoFactorKeysViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 19..
//

import Foundation
import TiqrCoreObjC
import OpenAPIClient

class TwoFactorKeysViewModel {
    
    let personalInfo: UserResponse
    
    var didRemoveIdentities = false
    
    init(personalInfo: UserResponse) {
        self.personalInfo = personalInfo
    }
    
    func getIdentityList() async throws -> [Identity] {
        let controller = ServiceContainer.sharedInstance().identityService.createFetchedResultsControllerForIdentities()!
        try controller.performFetch()
        return controller.sections?[0].objects as! [Identity]
    }
    
    func setIdentityBiometricsEnabled(identity: Identity, biometricsEnabled: Bool) {
        identity.biometricIDEnabled = NSNumber(value: biometricsEnabled)
        ServiceContainer.sharedInstance().identityService.saveIdentities()
    }
    
    func removeIdentity(identity: Identity) {
        let identityService = ServiceContainer.sharedInstance().identityService!
        let identityProvider = identity.identityProvider
        
        if identityProvider != nil {
            identityProvider!.removeIdentitiesObject(identity)
            identityService.delete(identity)
            if identityProvider!.identities.count == 0 {
                identityService.delete(identityProvider)
            }
        } else {
            identityService.delete(identity)
        }
        identityService.saveIdentities()
        didRemoveIdentities = true
    }
}
