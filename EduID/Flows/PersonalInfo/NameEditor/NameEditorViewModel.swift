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

    var currentFirstName: String
    var modifiedFirstName: String?
    var currentLastName: String
    var modifiedLastName: String?
    
    let editLastNameAllowed: Bool
    
    init(personalInfo: UserResponse) {
        currentFirstName = personalInfo.chosenName ?? personalInfo.givenName ?? ""
        currentLastName = personalInfo.familyName ?? ""
        editLastNameAllowed = personalInfo.linkedAccounts?.isEmpty != false
    }
    
    func updateValidation(with value: String, isValid: Bool, from tag: Int) {
        if tag == NameEditorViewModel.TAG_FIRST_NAME {
            modifiedFirstName = value
        } else if tag == NameEditorViewModel.TAG_LAST_NAME {
            modifiedLastName = value
        }
        
        let effectiveFirstName = modifiedFirstName ?? currentFirstName
        let effectiveLastName = modifiedLastName ?? currentLastName

        let firstNameChanged = modifiedFirstName != nil && modifiedFirstName != currentFirstName
        let lastNameChanged = modifiedLastName != nil && modifiedLastName != currentLastName

        let firstNameIsValid = !effectiveFirstName.trimmingCharacters(in: .whitespaces).isEmpty
        let lastNameIsValid = editLastNameAllowed
            ? !effectiveLastName.trimmingCharacters(in: .whitespaces).isEmpty
            : true

        
        let shouldEnableButton = firstNameIsValid
            && lastNameIsValid
            && (firstNameChanged || lastNameChanged)

        setSaveButtonEnabled?(shouldEnableButton)
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
