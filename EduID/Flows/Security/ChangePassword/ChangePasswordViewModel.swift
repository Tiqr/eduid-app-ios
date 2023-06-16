import UIKit

class ChangePasswordViewModel: NSObject {
    
    //MARK: - closures that interact with the view controller
    var setRequestButtonEnabled: ((Bool) -> Void)?
    var makeNextTextFieldFirstResponderClosure: ((Int) -> Void)?
    var textFieldBecameFirstResponderClosure: ((Int) -> Void)?
    
    var validationMap: [Int: Bool] = [1:false, 3:false, 4: false] {
        didSet {
            var isTrue = true
            validationMap.forEach({ (key: Int, value: Bool) in
                if !value {
                    isTrue = false
                }
            })
            setRequestButtonEnabled?(isTrue)
        }
    }
}

//MARK: - textfield delegate
extension ChangePasswordViewModel: ValidatedTextFieldDelegate {
    
    func updateValidation(with value: String, isValid: Bool, from tag: Int) {
        validationMap[tag] = isValid
    }
    
    func keyBoardDidReturn(tag: Int) {
        makeNextTextFieldFirstResponderClosure?(tag)
    }
    
    func didBecomeFirstResponder(tag: Int) {
        textFieldBecameFirstResponderClosure?(tag)
    }
}
