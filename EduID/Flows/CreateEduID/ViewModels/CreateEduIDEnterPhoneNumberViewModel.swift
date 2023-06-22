import Foundation
import OpenAPIClient

class CreateEduIDEnterPhoneNumberViewModel: NSObject {
    
    //MARK: - closures
    var phoneNumberReceivedClosure: ((FinishEnrollment) -> Void)?
    
    //MARK: - init
    override init() {
        super.init()
    }
    
    @MainActor
    func sendPhoneNumber(number: String) {
        Task {
            do {
                let result = try await TiqrControllerAPI.sendPhoneCodeForSpWithRequestBuilder(phoneCode: PhoneCode(phoneNumber: number))
                    .execute()
                    .body
                phoneNumberReceivedClosure?(result)
            } catch let error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
