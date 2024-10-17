import UIKit
import OpenAPIClient

class ActivityViewModel: NSObject {
    
    var userResponse: UserResponse?
    var tokensResponse: [Token]?
    
    // - closures
    var dataAvailableClosure: ((PersonalInfoDataCallbackModel) -> Void)?
    var serviceRemovedClosure: ((LinkedAccount) -> Void)?
    var dataFetchErrorClosure: ((EduIdError) -> Void)?
    
    override init() {
        super.init()
    }
    
    func getData() {
        if AppAuthController.shared.hasPendingAuthFlow {
            AppAuthController.shared.pendingTaskUntilAuthCompletes = { [weak self ]_ in
                self?.getData()
            }
            return
        }
        Task {
            do {
                try await userResponse = UserControllerAPI.me()
                try await tokensResponse = UserControllerAPI.tokens()
                
                await processUserData()
                
            } catch {
                await processError(with: error)
            }
        }
    }
    
    @MainActor
    private func processError(with error: Error) {
        dataFetchErrorClosure?(EduIdError.from(error))
    }
    
    @MainActor
    private func processUserData() {
        guard let userResponse,
            let tokensResponse else {
            return
        }
        let name: String
        if userResponse.linkedAccounts?.isEmpty ?? true {
            let nameProvidedBy = L.Profile.Me.localization
            dataAvailableClosure?(
                PersonalInfoDataCallbackModel(
                    userResponse: userResponse,
                    tokensResponse: tokensResponse,
                    firstName: userResponse.givenName,
                    lastName: userResponse.familyName,
                    nameProvidedBy: nameProvidedBy,
                    isNameProvidedByInstitution: false
            ))
        } else {
            guard let firstLinkedAccount = userResponse.linkedAccounts?.first else { return }
            let nameProvidedBy = firstLinkedAccount.schacHomeOrganization ?? ""
            let model = PersonalInfoDataCallbackModel(
                userResponse: userResponse,
                tokensResponse: tokensResponse,
                firstName: firstLinkedAccount.givenName,
                lastName: firstLinkedAccount.familyName,
                nameProvidedBy: nameProvidedBy,
                isNameProvidedByInstitution: true
            )
            
            dataAvailableClosure?(model)
        }
    }
    
    func removeLinkedAccount(linkedAccount: LinkedAccount) {
        Task {
            do {
                let result = try await UserControllerAPI.removeUserLinkedAccountsWithRequestBuilder(updateLinkedAccountRequest: UpdateLinkedAccountRequest(
                    eduPersonPrincipalName: linkedAccount.eduPersonPrincipalName,
                    subjectId: linkedAccount.subjectId,
                    external: linkedAccount.external,
                    idpScoping: nil
                    )
                ).execute().body
                
                if !(result.linkedAccounts?.contains(linkedAccount) ?? true) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.serviceRemovedClosure?(linkedAccount)
                    }
                }
            } catch let error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
