//
//  SelectYourBankViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 01/10/2024.
//
import OpenAPIClient

class SelectYourBankViewModel: NSObject {
    
    var issuers: [VerifyIssuer]?
    
    var dataAvailableClosure: (([VerifyIssuer]) -> Void)?
    var dataFetchErrorClosure: ((String, String, Int) -> Void)?
    
    func fetchIssuerList() {
        Task {
            do {
                try await issuers = AccountLinkerControllerAPI.issuers()
                await processIssuersList()
            } catch {
                await processError(with: error)
            }
        }
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
