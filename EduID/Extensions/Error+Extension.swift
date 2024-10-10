import Foundation
import OpenAPIClient

// Custom error class to handle eduId API response errors
class EduIdError: Error {
    let title: String
    let message: String
    let statusCode: Int
    
    init(title: String, message: String, statusCode: Int) {
        self.title = title
        self.message = message
        self.statusCode = statusCode
    }
    
    // Factory method to generate CustomError from ErrorResponse
    static func from(_ error: Error) -> EduIdError {
        if let response = error as? ErrorResponse {
            switch response {
            case let .error(statusCode, _, _, _):
                return EduIdError.generateError(for: statusCode)
            }
        }
        return EduIdError(title: "Unknown Error", message: "An unknown error occurred.", statusCode: -1)
    }
    
    // Generate the appropriate error based on the status code
    private static func generateError(for statusCode: Int) -> EduIdError {
        switch statusCode {
        case 401:
            return EduIdError(
                title: L.ResponseErrors.UnauthorizedTitle.localization,
                message: L.ResponseErrors.UnauthorizedText.localization,
                statusCode: statusCode
            )
        case 403:
            return EduIdError(
                title: L.ResponseErrors.SMSErrorTitle.localization,
                message: L.ResponseErrors.SMSErrorText.localization,
                statusCode: statusCode
            )
        case 409:
            return EduIdError(
                title: L.ResponseErrors.EmailInUse.Title.localization,
                message: L.ResponseErrors.EmailInUse.Description.localization,
                statusCode: statusCode
            )
        case 412:
            return EduIdError(
                title: L.ResponseErrors.ForbiddenDomainTitle.localization,
                message: L.ResponseErrors.ForbiddenDomainText.localization,
                statusCode: statusCode
            )
        case -1:
            return EduIdError(
                title: L.ResponseErrors.NoInternetAccessTitle.localization,
                message: L.ResponseErrors.NoInternetAccessText.localization,
                statusCode: statusCode
            )
        default:
            return EduIdError(
                title: "\(statusCode) \(L.ResponseErrors.NoInternetAccessTitle.localization)",
                message: "\(L.ResponseErrors.UnknownErrorText.localization) \(statusCode)",
                statusCode: statusCode
            )
        }
    }
}
