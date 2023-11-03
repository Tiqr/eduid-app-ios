//
//  ConfirmDeleteViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 15..
//

import Foundation
import OpenAPIClient

class ConfirmDeleteViewModel: ValidatedTextFieldDelegate {

    let personalInfo: UserResponse
    
    var setConfirmButtonEnabled: ((Bool) -> Void)?
    var hideKeyboard: (() -> Void)?

    var currentFullName: String = ""
    
    init(personalInfo: UserResponse) {
        self.personalInfo = personalInfo
    }
    
    func checkIfNameMatches() -> Error? {
        let expectedFullName : String
        if let familyName = personalInfo.familyName,
           let givenName = personalInfo.givenName {
            expectedFullName = "\(givenName) \(familyName)"
        } else if let familyName = personalInfo.familyName {
            expectedFullName = familyName
        } else if let givenName = personalInfo.givenName {
            expectedFullName = givenName
        } else {
            expectedFullName = ""
        }
        if expectedFullName.lowercased() == currentFullName.lowercased() {
            return nil
        } else {
            return NameMismatchError(expectedName: expectedFullName)
        }
    }
    
    func confirmDelete() async throws -> StatusResponse {
        return try await UserControllerAPI.deleteUser()
    }
    
    func updateValidation(with value: String, isValid: Bool, from tag: Int) {
        currentFullName = value
        setConfirmButtonEnabled?(isValid)
    }
    
    func keyBoardDidReturn(tag: Int) {
        hideKeyboard?()
    }
    
    func didBecomeFirstResponder(tag: Int) {
        // No op
    }
    
    class NameMismatchError: LocalizedError, CustomStringConvertible {
        
        let expectedName: String
    
        init(expectedName: String) {
            self.expectedName = expectedName
        }

        var description: String { return L.ConfirmDelete.NameDoesNotMatchError.Description(args: expectedName).localization }

    }
}
