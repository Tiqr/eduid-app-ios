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
    var dataFetchErrorClosure: ((String, String, Int) -> Void)?
    
    func getData() async throws -> UserResponse? {
        do {
            self.personalInfo = try await UserControllerAPI.me()
            return self.personalInfo!
        } catch {
            await processError(with: error)
        }
        return nil
    }
    
    @MainActor
    private func processError(with error: Error) {
        dataFetchErrorClosure?(error.eduIdResponseError().title,
                               error.eduIdResponseError().message,
                               error.eduIdResponseError().statusCode)
    }
}
