//
//  LinkingSuccessViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2024. 10. 10..
//
import OpenAPIClient
import UIKit

class LinkingSuccessViewModel: NSObject {
    
    let linkedInstitution: String?
    let previousUserResponse: UserResponse?
    
    var userResponse: UserResponse?
    var dataHandler: ((Result<UserResponse, Error>) -> Void)?
    
    init(linkedInstitution: String?, previousUserResponse: UserResponse?) {
        self.linkedInstitution = linkedInstitution
        self.previousUserResponse = previousUserResponse
    }
    
    func getData() {
        Task {
            do {
                try await userResponse = UserControllerAPI.meWithRequestBuilder()
                    .execute()
                    .body
                await processUserData()
            } catch {
                await processError(with: error)
            }
        }
    }
    
    func getAddedAccount() -> VerifiedInformationModel? {
        guard let userResponse else {
            assertionFailure("Do not call this method before getData() finishes successfully!")
            return nil
        }
        if let linkedInstitution {
            if let linkedAccount = userResponse.linkedAccounts?.first(where: { $0.eduPersonPrincipalName == linkedInstitution }) {
                return VerifiedInformationModel(linkedAccount: linkedAccount)
            }
            if let externalLinkedAccount = userResponse.externalLinkedAccounts?.first(where: { $0.issuer?.id == linkedInstitution }) {
                return VerifiedInformationModel(externalLinkedAccount: externalLinkedAccount)
            }
        }
        if let previousUserResponse {
            // Fallback: check if there are any new linked (external) accounts
            let allPreviousAccounts = previousUserResponse.linkedAccounts?.map { $0.eduPersonPrincipalName } ?? []
            let allPreviousExternalAccount = previousUserResponse.externalLinkedAccounts?.map(\.issuer?.id) ?? []
            for linkedAccount in (userResponse.linkedAccounts ?? []) {
                if !allPreviousAccounts.contains(linkedAccount.eduPersonPrincipalName) {
                    return VerifiedInformationModel(linkedAccount: linkedAccount)
                }
            }
            for externalLinkedAccount in (userResponse.externalLinkedAccounts ?? []) {
                if !allPreviousExternalAccount.contains(externalLinkedAccount.issuer?.id) {
                    return VerifiedInformationModel(externalLinkedAccount: externalLinkedAccount)
                }
            }
        }
        return nil
    }
    
    @MainActor
    private func processError(with error: Error) {
        dataHandler?(.failure(EduIdError.from(error)))
    }
    
    @MainActor
    private func processUserData() {
        guard let userResponse = userResponse else { return }
        dataHandler?(.success(userResponse))
    }
    
}
