import UIKit
import OpenAPIClient

class PinViewModel: NSObject {
    
    var resignKeyboardFocus: (() -> Void)?
    var enableVerifyButton: ((Bool) -> Void)?
    var focusPinField: ((Int) -> Void)?
    weak var smsActivationHandlerDelegate: AlertErrorHandlerDelegate?
    
    /// When `true`, entering the SMS code uses the re-verification endpoint (used when the user is
    /// confirming an already-registered SMS recovery number), instead of the initial onboarding endpoint.
    private let isReVerification: Bool
    
    var pinValue: [Character] = ["0", "0", "0", "0", "0", "0"]
    
    init(isReVerification: Bool = false) {
        self.isReVerification = isReVerification
        super.init()
    }
    
    var pinIsEnteredOnTextFieldIndex: [Int: Bool] = [:] {
        didSet {
            var areAllEntriesEntered = true
            pinIsEnteredOnTextFieldIndex.forEach { (key, value) in
                if !value {
                    areAllEntriesEntered = false
                }
            }
            enableVerifyButton?(areAllEntriesEntered)
        }
    }
    
    @MainActor
    func enterSMS(code: String) {
        Task {
                do {
                    if isReVerification {
                        let _ = try await TiqrControllerAPI.spReverifyPhoneCodeWithRequestBuilder(phoneVerification: PhoneVerification(phoneVerification: code))
                            .execute()
                            .body
                    } else {
                        let _ = try await TiqrControllerAPI.spVerifyPhoneCodeWithRequestBuilder(phoneVerification: PhoneVerification(phoneVerification: code))
                            .execute()
                            .body
                    }
                    smsActivationHandlerDelegate?.smsEntryWasCorrect()
                } catch {
                    smsActivationHandlerDelegate?.presentAlert(with: error)
                }
        }
    }
    
    func performSMSDeactivation(with code: String) {
        Task {
                do {
                    let deactivateRequest = DeactivateRequest(verificationCode: code)
                    let _ = try await TiqrControllerAPI.deactivateApp(deactivateRequest: deactivateRequest)
                    smsActivationHandlerDelegate?.smsDeactivationWasSuccess()
                } catch {
                    smsActivationHandlerDelegate?.presentAlert(with: error)
                }
        }
    }
}

//MARK: - pin textfield delegate
extension PinViewModel: PinTextFieldDelegate {

    func didEnterPinNumber(range: Int, tag: Int, value: Character) {
        pinValue[tag] = value
        pinIsEnteredOnTextFieldIndex[tag] = true
        guard tag != range else {
            resignKeyboardFocus?()
            return }
            
        focusPinField?(tag)
    }
}
