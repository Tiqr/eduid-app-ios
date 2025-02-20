//
//  VerifyWithIdVerificationCodeViewModel.swift
//  eduID
//
//  Created by Yasser Farahi on 13/02/2025.
//

import Foundation
import Combine

class VerifyWithIdVerificationCodeViewModel {
    
    var person: VerifyPerson
    var generatedCode: String?
    
    init(person: VerifyPerson) {
        self.person = person
    }
    
}
