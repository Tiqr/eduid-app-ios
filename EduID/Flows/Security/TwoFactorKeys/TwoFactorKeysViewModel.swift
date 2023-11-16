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
    var identityCount = -1;
    
    init(personalInfo: UserResponse) {
        self.personalInfo = personalInfo
    }
    
    func getIdentityList() async throws -> [Identity] {
        let controller = ServiceContainer.sharedInstance().identityService.createFetchedResultsControllerForIdentities()!
        try controller.performFetch()
        let identityList = controller.sections?[0].objects as! [Identity]
        if (identityCount > 0) {
            if identityList.count < identityCount {
                didRemoveIdentities = true
            }
        }
        identityCount = identityList.count
        return identityList
    }
    
    func setIdentityBiometricsEnabled(identity: Identity, biometricsEnabled: Bool) {
        identity.biometricIDEnabled = NSNumber(value: biometricsEnabled)
        ServiceContainer.sharedInstance().identityService.saveIdentities()
    }
}
