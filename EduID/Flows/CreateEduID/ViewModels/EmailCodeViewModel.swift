//
//  EmailCodeViewModel.swift
//  eduID
//
//  Created by Yasser Farahi on 08/05/2025.
//

import Foundation
import UIKit
import Combine

class EmailCodeViewModel: NSObject {
    
    let email: String
    
    init(email: String) {
        self.email = email
        super.init()
    }
    
}
