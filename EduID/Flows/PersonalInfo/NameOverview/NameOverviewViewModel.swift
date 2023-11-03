//
//  NameOverviewViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 12..
//

import Foundation
import OpenAPIClient

class NameOverviewViewModel {
    
    var personalInfo: UserResponse
    
    var didUpdateData = false
    
    var serviceRemovedClosure: ((UserResponse) -> Void)?
    var linkAddedClosure: ((LinkedAccount) -> Void)?
    
    init(personalInfo: UserResponse) {
        self.personalInfo = personalInfo
    }
    
    func checkIfLinkingCompleted() {
        Task {
            do {
                let user = try await UserControllerAPI.me()
                // Check if there are new links
                user.linkedAccounts?.forEach { addedLink in
                    let match = personalInfo.linkedAccounts?.filter { existingLink in
                        addedLink.subjectId == existingLink.subjectId
                    }
                    if match?.isEmpty != false {
                        personalInfo = user
                        DispatchQueue.main.async { [weak self] in
                            self?.linkAddedClosure?(addedLink)
                        }
                        return
                    }
                }
                personalInfo = user
            } catch {
                NSLog("Unable to detect if user has added a new link to the account: \(error)")
            }
        }
    }
    
    func removeLinkedAccount(linkedAccount: LinkedAccount) {
        Task {
            do {
                let result = try await UserControllerAPI.removeUserLinkedAccountsWithRequestBuilder(linkedAccount: linkedAccount)
                    .execute()
                    .body
                didUpdateData = true
                personalInfo = result
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.serviceRemovedClosure?(result)
                }
            } catch let error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func getStartLinkAccount() async throws -> AuthorizationURL? {
        return try await AccountLinkerControllerAPI.startSPLinkAccountFlowWithRequestBuilder()
                .execute()
                .body
    }
    
}
