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
            return try await UserControllerAPI.updateEmail(updateEmailRequest: UpdateEmailRequest(email: email))
        } else {
            assertionFailure("currentEmail property not set in email editor!")
            return nil
        }
    }
    
    func confirmEmailUpdate(url: URL) async throws -> UserResponse? {
        if let hashParam = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == "h" })?.value {
            return try await UserControllerAPI.confirmUpdateEmail(h: hashParam)
        } else {
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
