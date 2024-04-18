//
//  NameEditorViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 14..
//

import Foundation
import OpenAPIClient

class NameEditorViewModel: ValidatedTextFieldDelegate {
    
    static let TAG_FIRST_NAME = 1
    static let TAG_LAST_NAME = 2
    
    var setSaveButtonEnabled: ((Bool) -> Void)?
    var hideKeyboard: (() -> Void)?

    private var firstNameIsValid = false
    private var lastNameIsValid = false
    
    var currentFirstName: String
    var currentLastName: String
    
    let editLastNameAllowed: Bool
    
    init(personalInfo: UserResponse) {
        currentFirstName = personalInfo.chosenName ?? personalInfo.givenName ?? ""
        currentLastName = personalInfo.familyName ?? ""
        editLastNameAllowed = personalInfo.linkedAccounts?.isEmpty != false
        if !editLastNameAllowed {
            lastNameIsValid = true
        }
    }
    
    func updateValidation(with value: String, isValid: Bool, from tag: Int) {
        if tag == NameEditorViewModel.TAG_FIRST_NAME {
            currentFirstName = value
            firstNameIsValid = isValid
        } else if tag == NameEditorViewModel.TAG_LAST_NAME {
            currentLastName = value
            lastNameIsValid = isValid
        }
        setSaveButtonEnabled?(firstNameIsValid && lastNameIsValid)
    }
    
    func saveNameChange(firstName: String, lastName: String) async throws -> UserResponse {
        return try await UserControllerAPI.updateUserProfile(
            updateUserNameRequest: UpdateUserNameRequest(chosenName: firstName, givenName: firstName, familyName: lastName)
        )
    }
    
    func keyBoardDidReturn(tag: Int) {
        hideKeyboard?()
    }
    
    func didBecomeFirstResponder(tag: Int) {
        // No op
    }
    
    
}
