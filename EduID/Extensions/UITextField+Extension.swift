//
//  UITextField+Extension.swift
//  
//
//  Created by Yasser Farahi on 06/04/2023.
//

import UIKit

extension UITextField {
    
    func isValid(with type: TextFieldValidationType, with stringValue: String) -> Bool {
        return regex(for: type).firstMatch(in: stringValue, options: [], range: NSRange(location: 0, length: stringValue.utf16.count)) != nil
    }
    
    private func regex(for type: TextFieldValidationType) -> NSRegularExpression {
        switch type {
        case .email:
            return try! NSRegularExpression(pattern: Constants.RegEx.emailRegex)
            
        case .name:
            return try! NSRegularExpression(pattern: Constants.RegEx.nameRegex)
            
        case .password:
            return try! NSRegularExpression(pattern: Constants.RegEx.passwordRegex)
            
        case .phone:
            return try! NSRegularExpression(pattern: Constants.RegEx.phoneRegex)
            
        }
    }
}
