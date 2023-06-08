import Foundation
import OpenAPIClient

class CreateEduIDFirstTimeDialogViewViewModel: NSObject {
    
    //MARK: - closures
    var addInstitutionsCompletion: ((AuthorizationURL) -> Void)?
    private let keychain = KeyChainService()
    
    @MainActor
    func gotoAddInstitutionsInBrowser() {
        Task {
            do {
                let result = try await AccountLinkerControllerAPI.startSPLinkAccountFlowWithRequestBuilder()
                    .execute()
                    .body
                
                addInstitutionsCompletion?(result)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
