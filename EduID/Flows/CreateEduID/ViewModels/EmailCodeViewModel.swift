//
//  EmailCodeViewModel.swift
//  eduID
//
//  Created by Yasser Farahi on 08/05/2025.
//

import Foundation
import UIKit
import Combine
import OpenAPIClient

class EmailCodeViewModel: NSObject {
    
    var email: String?
    var resendCodeSuccessClosure: (() -> Void)?
    var resendCodeErrorClosure: ((String, String ) -> Void)?
    var userCodeInPutSuccessClosure: (() -> Void)?
    var userCodeInPutErrorClosure: ((String, String ) -> Void)?
    
    override init() {
        super.init()
    }
    
    func resendCode(email: String) {
        Task {
            do {
                _ = try await UserControllerAPI.resendSpCodeMail()
                resendCodeSuccessClosure?()
            } catch {
                let error = EduIdError.from(error)
                resendCodeErrorClosure?(error.title, error.message)
            }
        }
    }
    

    func userCodeInPut(_ code: String) {
        Task {
            do {
                _ = try await UserControllerAPI.verifyChangeEmailCode(verifyOneTimeLoginCode: .init(code: code))
                userCodeInPutSuccessClosure?()
            } catch {
                let error = EduIdError.from(error)
                userCodeInPutErrorClosure?(error.title, error.message)
            }
        }
    }
}
