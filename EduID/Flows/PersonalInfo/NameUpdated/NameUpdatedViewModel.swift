//
//  NameUpdatedViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 13..
//

import Foundation
import OpenAPIClient

class NameUpdatedViewModel {
    
    let linkedAccount: LinkedAccount
    
    init(linkedAccount: LinkedAccount) {
        self.linkedAccount = linkedAccount
    }
    
}
