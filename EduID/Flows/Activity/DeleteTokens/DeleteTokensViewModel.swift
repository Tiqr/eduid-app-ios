//
//  DeleteServiceViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 15..
//

import Foundation
import OpenAPIClient

class DeleteTokensViewModel {
    
    let serviceName: String
    private let tokensToDelete: [Token]
    
    init(serviceName: String, tokensToDelete: [Token]) {
        self.serviceName = serviceName
        self.tokensToDelete = tokensToDelete
    }
    
    func deleteTokens() async throws -> UserResponse {
        let tokenRepresentations = tokensToDelete.map { TokenRepresentation(id: $0.id, type: $0.type?.toRepresentationType())}
        return try await UserControllerAPI.removeTokens(deleteServiceTokens: DeleteServiceTokens(tokens: tokenRepresentations))
    }
}

extension Token.ModelType {
    func toRepresentationType() -> TokenRepresentation.ModelType {
        switch self {
        case .access: return TokenRepresentation.ModelType.access
        case .refresh: return TokenRepresentation.ModelType.refresh
        }
    }
}
