import UIKit
import OpenAPIClient
import Combine

class CreateEduIDRegistrationCheckViewModel: NSObject {

    private let isExistingUser = CurrentValueSubject<Bool, Never>(false)
    private let shouldDisplayError = CurrentValueSubject<Error?, Never>(nil)
    
    var isExistingUserPublisher: AnyPublisher<Bool, Never> {
        return isExistingUser.eraseToAnyPublisher()
    }
    
    var shouldDisplayErrorPublisher: AnyPublisher<Error?, Never> {
        return shouldDisplayError.eraseToAnyPublisher()
    }
    
    @MainActor
    func checkForAnyExistingUser() async {
        do {
            let userResponse = try await UserControllerAPI.me()
            if let loginOptions = userResponse.loginOptions,
                let registration = userResponse.registration {
                if loginOptions.contains(Constants.RegistrationCheck.useApp) && registration[Constants.RegistrationCheck.phoneVerified] == true {
                    let _ = try await TiqrControllerAPI.sendDeactivationPhoneCodeForSp()
                    isExistingUser.send(true)
                } else {
                    isExistingUser.send(false)
                }
            }
        } catch {
            shouldDisplayError.send(error)
        }
    }
}
