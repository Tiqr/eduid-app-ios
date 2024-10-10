//
//  YourVerifiedInformationViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 11/04/2024.
//

import Foundation
import OpenAPIClient

class YourVerifiedInformationViewModel {
    
    let userResponse: UserResponse
    
    init(userResponse: UserResponse) {
        self.userResponse = userResponse
    }
    
    func removeLinkedAccount(
        request: UpdateLinkedAccountRequest,
        onRemoved: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        Task {
            do {
                let result = try await UserControllerAPI.removeUserLinkedAccountsWithRequestBuilder(updateLinkedAccountRequest: request)
                    .execute()
                    .body
                DispatchQueue.main.async {
                    onRemoved()
                }
            } catch let error {
                assertionFailure(error.localizedDescription)
                onError(error)
            }
        }
    }
}

extension UserResponse {
    func getAllModels() -> [VerifiedInformationModel] {
        var result = [VerifiedInformationModel]()
        result.append(contentsOf: linkedAccounts?.map { VerifiedInformationModel(linkedAccount: $0) } ?? [])
        result.append(contentsOf: externalLinkedAccounts?.map { VerifiedInformationModel(externalLinkedAccount: $0) } ?? [])
        return result
    }
}


class VerifiedInformationModel: Equatable {
    let givenName: String?
    let familyName: String?
    let providerName: String
    let createdAt: Int64?
    let expiresAt: Int64?
    let eduPersonAffiliations: [String]?
    
    let removeRequest: UpdateLinkedAccountRequest
    
    init(linkedAccount: LinkedAccount) {
        givenName = linkedAccount.givenName
        familyName = linkedAccount.familyName
        providerName = linkedAccount.schacHomeOrganization ?? linkedAccount.institutionIdentifier ?? ""
        createdAt = linkedAccount.createdAt
        expiresAt = linkedAccount.expiresAt
        eduPersonAffiliations = linkedAccount.eduPersonAffiliations
        removeRequest = UpdateLinkedAccountRequest(
            eduPersonPrincipalName: linkedAccount.eduPersonPrincipalName,
            subjectId: linkedAccount.subjectId,
            external: linkedAccount.external,
            idpScoping: nil
        )
    }
    
    init(externalLinkedAccount: ExternalLinkedAccount) {
        givenName = externalLinkedAccount.firstName
        familyName = externalLinkedAccount.preferredLastName ?? externalLinkedAccount.legalLastName
        providerName = externalLinkedAccount.issuer?.name ?? externalLinkedAccount.issuer?.id ?? "?"
        createdAt = externalLinkedAccount.createdAt
        expiresAt = externalLinkedAccount.expiresAt
        eduPersonAffiliations = nil
        removeRequest = UpdateLinkedAccountRequest(
            eduPersonPrincipalName: nil,
            subjectId: externalLinkedAccount.subjectId,
            external: externalLinkedAccount.external,
            idpScoping: externalLinkedAccount.idpScoping?.rawValue
        )
    }
    
    // Conform to the Equatable protocol
    static func == (lhs: VerifiedInformationModel, rhs: VerifiedInformationModel) -> Bool {
        return lhs.givenName == rhs.givenName &&
               lhs.familyName == rhs.familyName &&
               lhs.providerName == rhs.providerName &&
               lhs.createdAt == rhs.createdAt &&
               lhs.expiresAt == rhs.expiresAt &&
               lhs.eduPersonAffiliations == rhs.eduPersonAffiliations &&
               lhs.removeRequest == rhs.removeRequest
    }
}
