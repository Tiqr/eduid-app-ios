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
    
    private var createEduIDResponseHash: String? {
        return UserDefaults.standard.string(forKey: CreateEduIDEnterPersonalInfoViewModel.createEduIDResponseKeyUserDefaults)
    }
    
    var email: String? {
        return UserDefaults.standard.string(forKey: CreateEduIDEnterPersonalInfoViewController.emailKeyUserDefaults)
    }
    
    private var changeEmailFlow: Bool
    var resendCodeSuccessClosure: (() -> Void)?
    var resendCodeErrorClosure: ((String, String ) -> Void)?
    var userCodeInPutSuccessClosure: ((URL?) -> Void)?
    var userEmailChangeSuccessClosure: (() -> Void)?
    var userCodeInPutErrorClosure: ((String, String ) -> Void)?
    
    init(changeEmailFlow: Bool = false) {
        self.changeEmailFlow = changeEmailFlow
    }
    
    func resendCode() {
        Task {
            do {
                if changeEmailFlow {
                    _ = try await UserControllerAPI.resendSpCodeMail()
                    resendCodeSuccessClosure?()
                } else {
                    _ = try await UserControllerAPI.resendCodeMailMobile(hash: createEduIDResponseHash ?? "")
                    resendCodeSuccessClosure?()
                }
            } catch {
                let error = EduIdError.from(error, kind: .createAccountEmailCode)
                resendCodeErrorClosure?(error.title, error.message)
            }
        }
    }
    
    func userCodeInPut(_ code: String) {
        Task {
            do {
                if changeEmailFlow {
                    try await changeEmail(with: code)
                    
                } else {
                    try await createAccount(with: code)
                }
            } catch {
                let error = EduIdError.from(error, kind: .createAccountEmailCode)
                userCodeInPutErrorClosure?(error.title, error.message)
            }
        }
    }
    
    private func changeEmail(with code: String) async throws {
        let result: [String: String] = try await UserControllerAPI.verifyChangeEmailCode(verifyOneTimeLoginCode: .init(code: code))
        let hash: String? = result["hash"]
        _ = try await UserControllerAPI.confirmUpdateEmail(h: hash ?? "")
        userEmailChangeSuccessClosure?()
    }
    
    private func createAccount(with code: String) async throws {
        struct VerifyCodeMobileUserResponse: Codable {
            let url: URL
        }
        
        if let data = try await UserControllerAPI.verifyCodeMobileUser(verifyOneTimeLoginCode: .init(code: code, hash: createEduIDResponseHash)).data(using: .utf8) {
            let response = try JSONDecoder().decode(VerifyCodeMobileUserResponse.self, from: data)
            let url = response.url
            userCodeInPutSuccessClosure?(url)
        }
    }
}
