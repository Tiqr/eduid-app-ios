import UIKit
import OpenAPIClient

class PersonalInfoViewModel: NSObject {
    
    var userResponse: UserResponse?

    // - closures
    var dataAvailableClosure: ((PersonalInfoDataCallbackModel) -> Void)?
    var serviceRemovedClosure: ((LinkedAccount) -> Void)?
    var dataFetchErrorClosure: ((String, String, Int) -> Void)?
    private let defaults = UserDefaults.standard
    
    var viewController: CreateEduIDAddInstitutionViewController?
    
    init(_ loadData: Bool) {
        super.init()
        if loadData {
            getData()
        }
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
    
    @MainActor
    private func processError(with error: Error) {
        dataFetchErrorClosure?(error.eduIdResponseError().title,
                               error.eduIdResponseError().message,
                               error.eduIdResponseError().statusCode)
    }
    
    @MainActor
    private func processUserData() {
        guard let userResponse = userResponse else { return }
        if userResponse.linkedAccounts?.isEmpty ?? true {
            let nameProvidedBy = L.Profile.Me.localization
            dataAvailableClosure?(
                PersonalInfoDataCallbackModel(
                    userResponse: userResponse,
                    tokensResponse: [],
                    firstName: userResponse.givenName,
                    lastName: userResponse.familyName,
                    nameProvidedBy: nameProvidedBy,
                    isNameProvidedByInstitution: false
                )
            )
        } else {
            guard let firstLinkedAccount = userResponse.linkedAccounts?.first else { return }
            let nameProvidedBy = firstLinkedAccount.schacHomeOrganization ?? ""
            let model = PersonalInfoDataCallbackModel(
                userResponse: userResponse,
                tokensResponse: [],
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
                let result = try await UserControllerAPI.removeUserLinkedAccountsWithRequestBuilder(linkedAccount: linkedAccount)
                    .execute()
                    .body
                
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
    
    func getStartLinkAccount() async throws -> AuthorizationURL? {
        return try await AccountLinkerControllerAPI.startSPLinkAccountFlowWithRequestBuilder()
                .execute()
                .body
    }
}

extension PersonalInfoViewModel {
    
    @objc func createAccount() {
        guard let viewController = self.viewController else { return }
        viewController.showNextScreen()
        let biometryStatus = defaults.bool(forKey: Constants.BiometricDefaults.key)
        defaults.set(biometryStatus ? OnboardingFlowType.existingUserWithSecret.rawValue
                     : OnboardingFlowType.existingUserWithSecret.rawValue,
                     forKey: OnboardingManager.userdefaultsFlowTypeKey)
        
    }
}

struct PersonalInfoDataCallbackModel {
    var userResponse: UserResponse
    var tokensResponse: [Token]
    var firstName: String?
    var lastName: String?
    var nameProvidedBy: String
    var isNameProvidedByInstitution: Bool
}
