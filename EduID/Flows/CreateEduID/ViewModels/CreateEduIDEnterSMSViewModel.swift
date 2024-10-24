import Foundation
import OpenAPIClient

class CreateEduIDEnterSMSViewModel: NSObject {
    
    //MARK: - closures
    var smsEntryWasCorrect: ((VerifyPhoneCode) -> Void)?
    var smsEntryFailed: ((String, String) -> Void)?
    
    func enterSMS(code: String) {
        Task {
            do {
                let result = try await TiqrControllerAPI.spVerifyPhoneCodeWithRequestBuilder(phoneVerification: PhoneVerification(phoneVerification: code))
                    .execute()
                    .body
                smsEntryWasCorrect?(result)
            } catch {
                let responseError = EduIdError.from(error)
                smsEntryFailed?(responseError.title, responseError.message)
            }
        }
    }
}
