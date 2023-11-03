import UIKit

protocol EduIDPinFieldDelegate: AnyObject {
    func textFieldDidDelete()
}

class EduIDPinField: UITextField {
    
    weak var eduIDPinFieldDelegate: EduIDPinFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        eduIDPinFieldDelegate?.textFieldDidDelete()
    }
}
