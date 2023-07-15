import UIKit
import OpenAPIClient
import Combine

class CreateEduIDRegistrationCheckViewModel: NSObject {

    private let existingUser = CurrentValueSubject<Bool?, Never>(nil)
    private let error = CurrentValueSubject<Error?, Never>(nil)
    
    var existingUserPublisher: AnyPublisher<Bool?, Never> {
        return existingUser.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error?, Never> {
        return error.eraseToAnyPublisher()
    }
    
    @MainActor
    func checkForAnyExistingUser() async {
        do {
            let userResponse = try await UserControllerAPI.me()
            if let loginOptions = userResponse.loginOptions,
                let registration = userResponse.registration {
                if loginOptions.contains(Constants.RegistrationCheck.useApp) && registration[Constants.RegistrationCheck.phoneVerified] == true {
                    let _ = try await TiqrControllerAPI.sendDeactivationPhoneCodeForSp()
                    existingUser.send(true)
                } else {
                    existingUser.send(false)
                }
            }
        } catch {
            self.error.send(error)
        }
    }
}
