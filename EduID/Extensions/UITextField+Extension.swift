import UIKit

extension UITextField {
    
    func isValid(with type: TextFieldValidationType, with stringValue: String) -> Bool {
        var anySatisfy = false
        // Password check has two regex checks, one for a shorter and one for a longer password.
        // If any of those match, we consider the whole field valid.
        // For the other fields, there's just one regex checked.
        regex(for: type).forEach { expr in
            if !anySatisfy {
                if expr.firstMatch(in: stringValue, options: [], range: NSRange(location: 0, length: stringValue.utf16.count)) != nil {
                    anySatisfy = true
                }
            }
        }
        return anySatisfy
    }
    
    private func regex(for type: TextFieldValidationType) -> [NSRegularExpression] {
        switch type {
        case .email:
            return [try! NSRegularExpression(pattern: Constants.RegEx.emailRegex)]
            
        case .name:
            return [try! NSRegularExpression(pattern: Constants.RegEx.nameRegex)]
            
        case .password:
            return [try! NSRegularExpression(pattern: Constants.RegEx.shortPasswordRegex), try! NSRegularExpression(pattern: Constants.RegEx.longPasswordRegex)]
            
        case .phone:
            return [try! NSRegularExpression(pattern: Constants.RegEx.phoneRegex)]
            
        }
    }
}
