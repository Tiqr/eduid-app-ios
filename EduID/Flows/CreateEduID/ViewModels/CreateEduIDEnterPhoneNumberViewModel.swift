import Foundation
import OpenAPIClient

class CreateEduIDEnterPhoneNumberViewModel: NSObject {
    
    //MARK: - closures
    var phoneNumberReceivedClosure: ((FinishEnrollment) -> Void)?
    weak var alertErrorHandlerDelegate: AlertErrorHandlerDelegate?
    
    /// When `true`, the phone code is (re)sent using the re-verification endpoint (used when the user
    /// is confirming an already-registered SMS recovery number), instead of the initial onboarding endpoint.
    let isReVerification: Bool
    
    //MARK: - init
    init(isReVerification: Bool = false) {
        self.isReVerification = isReVerification
        super.init()
    }
    
    @MainActor
    func sendPhoneNumber(number: String) {
        Task {
            do {
                let result: FinishEnrollment
                if isReVerification {
                    result = try await TiqrControllerAPI.resendPhoneCodeForSpWithRequestBuilder(phoneCode: PhoneCode(phoneNumber: number))
                        .execute()
                        .body
                } else {
                    result = try await TiqrControllerAPI.sendPhoneCodeForSpWithRequestBuilder(phoneCode: PhoneCode(phoneNumber: number))
                        .execute()
                        .body
                }
                phoneNumberReceivedClosure?(result)
            } catch let error {
                alertErrorHandlerDelegate?.presentAlert(with: error)
            }
        }
    }
}
