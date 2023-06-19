//
//  LocalizedError+errorDescription.swift
//
//  Taken from: https://stackoverflow.com/a/43693876/1395437
//
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 15..
//

import Foundation
import OpenAPIClient

extension LocalizedError where Self: CustomStringConvertible {

   var errorDescription: String? {
      return description
   }
}

struct APIError : Decodable {
    var error: String? = nil
    var exception: String? = nil
}

/**
 * This helper extension checks if the error comes from the API. If yes, it will try to retrieve the actual error strings sent by the API, so that we can display them to the user.
 */
extension Error {
    var localizedFromApi: String {
        if self is ErrorResponse {
            switch self as! ErrorResponse {
            case let .error(_, data, _, _):
                if let data = data,
                   let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                    return "\(apiError.error ?? "") \(apiError.exception ?? "")".trimmingCharacters(in: CharacterSet(charactersIn: " "))
                }
            }
        }
        return localizedDescription
    }
 }
