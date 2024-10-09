//
//  SelectYourBankViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 01/10/2024.
//
import OpenAPIClient
import UIKit

class SelectYourBankViewModel: NSObject {
    
    var issuers: [VerifyIssuer]?
    
    var dataAvailableClosure: (([VerifyIssuer]) -> Void)?
    var dataFetchErrorClosure: ((String, String, Int) -> Void)?
    
    func fetchIssuerList() {
        Task {
            do {
                issuers = try await AccountLinkerControllerAPI.issuers()
                await processIssuersList()
            } catch {
                await processError(with: error)
            }
        }
    }
    
    func openIssuerLink(with issuer: VerifyIssuer, control: SelectBankOptionControl) {
        control.isLoading = true
        Task {
            do {
                let authUrl = try await AccountLinkerControllerAPI.startSPVerifyIDLinkAccountFlow(
                    idpScoping: AccountLinkerControllerAPI.IdpScoping_startSPVerifyIDLinkAccountFlow.idin,
                    bankId: issuer.id
                ).url
                await openAuthUrl(URL(string: authUrl!)!, control: control)
            } catch {
                await processError(with: error)
            }
        }
    }
    
    @MainActor
    func openAuthUrl(_ url: URL, control: SelectBankOptionControl) {
        control.isLoading = false
        UIApplication.shared.open(url)
    }
    
    @MainActor
    private func processIssuersList() {
        if let issuers {
            dataAvailableClosure?(issuers)
        }
    }
    
    @MainActor
    private func processError(with error: Error) {
        dataFetchErrorClosure?(error.eduIdResponseError().title,
                               error.eduIdResponseError().message,
                               error.eduIdResponseError().statusCode)
    }
    
}
