//
//  File.swift
//  
//
//  Created by Yasser Farahi on 13/04/2023.
//

import LocalAuthentication

class BiometricService {
    
    private let laContext = LAContext()
    
    func useOnDeviceBiometricFeature(completion: @escaping((Bool, LAError?) -> Void)) {
        var error: NSError?
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to access the app") { success, error in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        if let err = error as? LAError {
                            completion(false, err)
                        }
                    }
                }
            }
        } else {
            completion(false, error as? LAError)
        }
    }
}
