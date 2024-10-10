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
        _ linkedAccount: LinkedAccount,
        onRemoved: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        Task {
            do {
                let result = try await UserControllerAPI.removeUserLinkedAccountsWithRequestBuilder(updateLinkedAccountRequest: UpdateLinkedAccountRequest(
                    eduPersonPrincipalName: linkedAccount.eduPersonPrincipalName,
                    subjectId: linkedAccount.subjectId,
                    external: linkedAccount.external,
                    idpScoping: nil
                    )
                )
                    .execute()
                    .body
                
                if !(result.linkedAccounts?.contains(linkedAccount) ?? true) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        onRemoved()
                    }
                }
            } catch let error {
                assertionFailure(error.localizedDescription)
                onError(error)
            }
        }
    }
}
