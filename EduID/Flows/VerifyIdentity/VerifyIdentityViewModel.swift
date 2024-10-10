//
//  VerifyIdentityViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2024. 10. 02..
//
import UIKit
import OpenAPIClient

class VerifyIdentityViewModel: NSObject {
    
    var dataFetchErrorClosure: ((String, String, Int) -> Void)?
    
    func startLinkingInstitution(_ control: VerifyIdentityControl) {
        control.isLoading = true
        Task {
            do {
                let authUrl = try await AccountLinkerControllerAPI.startSPLinkAccountFlow().url
                await openAuthUrl(URL(string: authUrl!)!, control: control)
            } catch {
                await processError(with: error, control: control)
            }
        }
    }
    
    func openEidasLink(_ control: VerifyIdentityControl) {
        control.isLoading = true
        Task {
            do {
                let authUrl = try await AccountLinkerControllerAPI.startSPVerifyIDLinkAccountFlow(
                    idpScoping: AccountLinkerControllerAPI.IdpScoping_startSPVerifyIDLinkAccountFlow.eherkenning,
                    bankId: nil
                ).url
                await openAuthUrl(URL(string: authUrl!)!, control: control)
            } catch {
                await processError(with: error, control: control)
            }
        }
    }
    
    @MainActor
    func openAuthUrl(_ url: URL, control: VerifyIdentityControl) {
        control.isLoading = false
        UIApplication.shared.open(url)
    }
    
    @MainActor
    private func processError(with error: Error, control: VerifyIdentityControl) {
        control.isLoading = false
        dataFetchErrorClosure?(error.eduIdResponseError().title,
                               error.eduIdResponseError().message,
                               error.eduIdResponseError().statusCode)
    }
    
}
