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

public enum EmailCodeFlow {
    case changeEmail
    case addPassword
    case unknown
}

class EmailCodeViewModel: NSObject {
    
    private var createEduIDResponseHash: String? {
        return UserDefaults.standard.string(forKey: CreateEduIDEnterPersonalInfoViewModel.createEduIDResponseKeyUserDefaults)
    }
    
    var email: String? {
        return UserDefaults.standard.string(forKey: CreateEduIDEnterPersonalInfoViewController.emailKeyUserDefaults)
    }
    
    private var emailCodeFlow: EmailCodeFlow
    var resendCodeSuccessClosure: (() -> Void)?
    var resendCodeErrorClosure: ((String, String ) -> Void)?
    var userCodeInPutSuccessClosure: ((URL?) -> Void)?
    var userEmailChangeSuccessClosure: (() -> Void)?
    var userCodeInPutErrorClosure: ((String, String ) -> Void)?
    var addPasswordSuccessClosure: (() -> Void)?
    var resendAddPasswordSuccessClosure: (() -> Void)?
    
    init(emailCodeFlow: EmailCodeFlow = .unknown) {
        self.emailCodeFlow = emailCodeFlow
    }
    
    func resendCode() {
        Task {
            do {
                switch emailCodeFlow {
                case .changeEmail:
                    _ = try await UserControllerAPI.resendSpCodeMail()
                    resendCodeSuccessClosure?()
                    
                case .addPassword:
                    _ = try await UserControllerAPI.resendSpCodePassword()
                    resendAddPasswordSuccessClosure?()
                    
                default:
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
                switch emailCodeFlow {
                case .changeEmail:
                    try await changeEmail(with: code)
                    
                case .addPassword:
                    try await addPassword(with: code)
                    
                default:
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
    
    private func addPassword(with code: String) async throws {
        let result = try await UserControllerAPI.verifyPasswordResetCode(verifyOneTimeLoginCode: .init(code: code))
        if let hash = result["hash"] {
            addPasswordSuccessClosure?()
        }
    }
}
