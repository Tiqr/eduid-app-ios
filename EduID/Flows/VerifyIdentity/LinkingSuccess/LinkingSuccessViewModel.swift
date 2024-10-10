//
//  LinkingSuccessViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2024. 10. 10..
//
import OpenAPIClient
import UIKit

class LinkingSuccessViewModel: NSObject {
    
    var userResponse: UserResponse?
    var dataHandler: ((Result<UserResponse, Error>) -> Void)?
    
    func getData() {
        Task {
            do {
                try await userResponse = UserControllerAPI.meWithRequestBuilder()
                    .execute()
                    .body
                await processUserData()
            } catch {
                await processError(with: error)
            }
        }
    }
    
    @MainActor
    private func processError(with error: Error) {
        dataHandler?(.failure(EduIdError.from(error)))
    }
    
    @MainActor
    private func processUserData() {
        guard let userResponse = userResponse else { return }
        dataHandler?(.success(userResponse))
    }
    
}
