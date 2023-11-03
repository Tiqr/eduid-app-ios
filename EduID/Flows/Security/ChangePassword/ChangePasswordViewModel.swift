import UIKit
import OpenAPIClient

class ChangePasswordViewModel {
    
    let isForAdd: Bool
    
    private let changeOrAddUrl: URL
    
    
    init(changeOrAddUrl: URL, isForAdd: Bool) {
        self.changeOrAddUrl = changeOrAddUrl
        self.isForAdd = isForAdd
    }
    
    //MARK: - closures that interact with the view controller
    var setRequestButtonEnabled: ((Bool) -> Void)?
    var makeNextTextFieldFirstResponderClosure: ((Int) -> Void)?
    var textFieldBecameFirstResponderClosure: ((Int) -> Void)?
    var passwordsMatchClosure: ((Bool) -> Void)?
    
    var passwordMap: [Int: String] = [2: "", 3: ""]
    var validationMap: [Int: Bool] = [2: false, 3: false] {
        didSet {
            var isTrue = true
            validationMap.forEach({ (key: Int, value: Bool) in
                if !value {
                    isTrue = false
                }
            })
            if isTrue {
                if passwordMap[2] != passwordMap[3] {
                    passwordsMatchClosure?(false)
                    return
                } else {
                    passwordsMatchClosure?(true)
                }
            }
            setRequestButtonEnabled?(isTrue)
        }
    }
    
    func getHash() throws -> String {
        var valueFound: String? = nil
        URLComponents(url: changeOrAddUrl, resolvingAgainstBaseURL: false)?.queryItems?.forEach { query in
            if query.name == "h" {
                valueFound = query.value
            }
        }
        if valueFound != nil {
            return valueFound!
        }
        throw MissingHashError()
    }
    
    func resetOrAddPassword() async throws -> UserResponse {
        return try await UserControllerAPI.updateUserPassword(
            updateUserSecurityRequest: UpdateUserSecurityRequest(newPassword: passwordMap[2]!, hash: try getHash())
        )
    }
    
    
    
    func deletePassword() async throws -> UserResponse {
        return try await UserControllerAPI.updateUserPassword(
            updateUserSecurityRequest: UpdateUserSecurityRequest(newPassword: "", hash: try getHash())
        )
    }
}

//MARK: - textfield delegate
extension ChangePasswordViewModel: ValidatedTextFieldDelegate {
    
    func updateValidation(with value: String, isValid: Bool, from tag: Int) {
        passwordMap[tag] = value
        validationMap[tag] = isValid
    }
    
    func keyBoardDidReturn(tag: Int) {
        makeNextTextFieldFirstResponderClosure?(tag)
    }
    
    func didBecomeFirstResponder(tag: Int) {
        textFieldBecameFirstResponderClosure?(tag)
    }
}

class MissingHashError: LocalizedError, CustomStringConvertible {

    var description: String { return L.ChangePassword.MissingHashError.localization }

}
