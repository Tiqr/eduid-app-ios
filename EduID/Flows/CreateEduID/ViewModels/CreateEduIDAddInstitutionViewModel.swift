import Foundation
import OpenAPIClient

class CreateEduIDFirstTimeDialogViewViewModel: NSObject {
    
    //MARK: - closures
    var addInstitutionsCompletion: ((AuthorizationURL) -> Void)?
    weak var alertErrorHandlerDelegate: AlertErrorHandlerDelegate?
    
    @MainActor
    func gotoAddInstitutionsInBrowser() {
        Task {
            do {
                let result = try await AccountLinkerControllerAPI.startSPLinkAccountFlowWithRequestBuilder()
                    .execute()
                    .body
                
                addInstitutionsCompletion?(result)
            } catch {
                alertErrorHandlerDelegate?.presentAlert(with: error)
            }
        }
    }
}
