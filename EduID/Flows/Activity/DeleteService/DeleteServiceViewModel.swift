//
//  DeleteServiceViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 15..
//

import Foundation
import OpenAPIClient

class DeleteServiceViewModel {
    
    let service: EduID
    
    init(service: EduID) {
        self.service = service
    }
    
    func deleteActivity() async throws -> UserResponse {
        return try await UserControllerAPI.removeUserService(deleteService: DeleteService(serviceProviderEntityId: service.serviceProviderEntityId!))
    }
    
}
