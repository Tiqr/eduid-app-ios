//
//  DeleteAccountViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 14..
//

import Foundation
import OpenAPIClient

class DeleteAccountViewModel {
    
    let personalInfo: UserResponse
    
    init(personalInfo: UserResponse) {
        self.personalInfo = personalInfo
    }
}
