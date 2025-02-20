//
//  VerifyWithIdVerificationCodeViewModel.swift
//  eduID
//
//  Created by Yasser Farahi on 13/02/2025.
//

import Foundation
import OpenAPIClient

class VerifyWithIdVerificationCodeViewModel: ObservableObject {
    
    let person: VerifyPerson
    let controlCode: String
    var userResponse: UserResponse?
    
    init(person: VerifyPerson, controlCode: String) {
        self.person = person
        self.controlCode = controlCode
    }

    func deleteVerificationCode() async {
        do {
            userResponse = try await UserControllerAPI.deleteUserControlCode()
        } catch {
            assertionFailure("Failed to delete user control code: \(error) -- \(error.localizedDescription)")
        }
    }
    
    func controlCodeIsStillValid() async -> Bool {
        do {
            userResponse = try await UserControllerAPI.me()
            return userResponse?.controlCode?.code != nil
        } catch {
            assertionFailure("Failed to check control code validation")
        }
        return false
    }
}
