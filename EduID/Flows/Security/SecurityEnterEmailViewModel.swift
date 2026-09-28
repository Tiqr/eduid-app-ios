//
//  SecurityEnterEmailViewModel.swift
//  eduID
//
//  Created by Yasser Farahi on 24/07/2025.
//

import Foundation
import UIKit
import OpenAPIClient

class SecurityEnterEmailViewModel: NSObject {
    
    var changeEmailErrorClosure: ((String, String ) -> Void)?
    var changeEmailSuccessClosure: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    deinit {}
    
    @MainActor
    func requestChange(email: String) {
        Task {
            do {
                _ = try await UserControllerAPI.generateEmailCode(updateEmailRequest: .init(email: email))
                changeEmailSuccessClosure?()
            } catch {
                let errorResponse = EduIdError.from(error)
                if errorResponse.statusCode == 409 {
                    // There is already a user with this email address (can also be the current user)
                    changeEmailErrorClosure?(L.ResponseErrors.EmailInUse.Title.localization,
                                             L.ResponseErrors.EmailInUse.Description.localization)
                } else {
                    changeEmailErrorClosure?(errorResponse.title, errorResponse.message)
                }
            }
        }
    }
}
