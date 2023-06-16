//
//  SecurityOverviewViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 16..
//

import Foundation
import OpenAPIClient

class SecurityOverviewViewModel {
    
    var personalInfo: UserResponse? = nil
    
    func getData() async throws -> UserResponse {
        return try await UserControllerAPI.me()
    }
    
}
