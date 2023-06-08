import UIKit
import OpenAPIClient

class ActivityViewModel: NSObject {
    
    var userResponse: UserResponse?
    
    // - closures
    var dataAvailableClosure: ((PersonalInfoDataCallbackModel) -> Void)?
    var serviceRemovedClosure: ((LinkedAccount) -> Void)?
    var dataFetchErrorClosure: ((Error) -> Void)?
    private let keychain = KeyChainService()
    
    override init() {
        super.init()
    }
    
    func loadData() {
        Task{
            await getData()
        }
    }
    
    @MainActor
    func getData() {
        Task {
            do {
                try await userResponse = UserControllerAPI.meWithRequestBuilder()
                    .execute()
                    .body
                
                processUserData()
            } catch {
                dataFetchErrorClosure?(error)
            }
        }
    }
    
    private func processUserData() {
        guard let userResponse = userResponse else {
            return
        }
        
        if userResponse.linkedAccounts?.isEmpty ?? true {
            let name = "\(userResponse.givenName?.first ?? "X"). \(userResponse.familyName ?? "")"
            let nameProvidedBy = LocalizedKey.Profile.me.localized
            dataAvailableClosure?(PersonalInfoDataCallbackModel(userResponse: userResponse, name: name, nameProvidedBy: nameProvidedBy, isNameProvidedByInstitution: false))
        } else {
            guard let firstLinkedAccount = userResponse.linkedAccounts?.first else { return }
            
            let name = "\(firstLinkedAccount.givenName?.first ?? "X"). \(firstLinkedAccount.familyName ?? "")"
            let nameProvidedBy = firstLinkedAccount.schacHomeOrganization ?? ""
            let model = PersonalInfoDataCallbackModel(userResponse: userResponse, name: name, nameProvidedBy: nameProvidedBy, isNameProvidedByInstitution: true)
            
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
}
