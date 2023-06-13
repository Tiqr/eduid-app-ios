//
//  EmailEditorViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 12..
//

import Foundation
import OpenAPIClient

class EmailEditorViewModel: ValidatedTextFieldDelegate {
    
    var setRequestButtonEnabled: ((Bool) -> Void)?
    var hideKeyboard: (() -> Void)?
    var currentEmail: String?
    
    
    func changeEmail() async throws -> UserResponse? {
        if let email = currentEmail {
            return try await UserControllerAPI.updateEmailWithRequestBuilder(updateEmailRequest: UpdateEmailRequest(email: email))
                .execute()
                .body
        } else {
            assertionFailure("currentEmail property not set in email editor!")
            return nil
        }
    }

    func updateValidation(with value: String, isValid: Bool, from tag: Int) {
        setRequestButtonEnabled?(isValid)
        currentEmail = value
    }
    
    func keyBoardDidReturn(tag: Int) {
        hideKeyboard?()
    }
    
    func didBecomeFirstResponder(tag: Int) {
        // No op
    }
    
    
    
    
}
