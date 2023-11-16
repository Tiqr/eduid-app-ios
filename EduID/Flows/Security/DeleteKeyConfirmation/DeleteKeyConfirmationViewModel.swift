//
//  DeleteKeyConfirmationViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 11. 16..
//

import Foundation
import TiqrCoreObjC

class DeleteKeyConfirmationViewModel {
    
    let identity: Identity
    
    init(identity: Identity) {
        self.identity = identity
    }
    
    func removeIdentity() {
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
    }
}
