import UIKit
import OpenAPIClient

class PinViewModel: NSObject {
    
    var resignKeyboardFocus: (() -> Void)?
    var enableVerifyButton: ((Bool) -> Void)?
    var focusPinField: ((Int) -> Void)?
    private let keychain = KeyChainService()
    
    var pinValue: [Character] = ["0", "0", "0", "0", "0", "0"]
    
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
    
    //MARK: - closures
    var smsEntryWasCorrect: ((VerifyPhoneCode) -> Void)?
    var smsEntryFailed: ((String, String) -> Void)?
    @MainActor
    func enterSMS(code: String) {
        Task {
                do {
                    let result = try await TiqrControllerAPI.spVerifyPhoneCodeWithRequestBuilder(phoneVerification: PhoneVerification(phoneVerification: code))
                        .execute()
                        .body
                    smsEntryWasCorrect?(result)
                } catch {
                    let responseError = error.eduIdResponseError()
                    smsEntryFailed?(responseError.title, responseError.message)
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
