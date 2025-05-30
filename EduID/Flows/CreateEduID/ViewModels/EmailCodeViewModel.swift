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
    
    var resendCodeSuccessClosure: (() -> Void)?
    var resendCodeErrorClosure: ((String, String ) -> Void)?
    var userCodeInPutSuccessClosure: ((URL?) -> Void)?
    var userCodeInPutErrorClosure: ((String, String ) -> Void)?
    
    override init() {
        super.init()
    }
    
    func resendCode() {
        Task {
            do {
                _ = try await UserControllerAPI.resendCodeMailMobile(hash: createEduIDResponseHash ?? "")
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
                struct VerifyCodeMobileUserResponse: Codable {
                    let url: URL
                }
                if let data = try await UserControllerAPI.verifyCodeMobileUser(verifyOneTimeLoginCode: .init(code: code, hash: createEduIDResponseHash)).data(using: .utf8) {
                    let response = try JSONDecoder().decode(VerifyCodeMobileUserResponse.self, from: data)
                    let url = response.url
                    userCodeInPutSuccessClosure?(url)
                }
            } catch {
                let error = EduIdError.from(error)
                userCodeInPutErrorClosure?(error.title, error.message)
            }
        }
    }
}
