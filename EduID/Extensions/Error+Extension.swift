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
    
    enum EduIdErrorKind {
        case regular
        case createAccountEmailCode
    }
    
    // Factory method to generate CustomError from ErrorResponse
    static func from(_ error: Error, kind: EduIdErrorKind = .regular) -> EduIdError {
        if let eduidError = error as? EduIdError {
            return eduidError
        }
        if let response = error as? ErrorResponse {
            switch response {
            case let .error(statusCode, data, _, _):
                if let errorFromResponse = tryParseResponseError(data, kind: kind) {
                    return errorFromResponse
                }
                switch kind {
                case .createAccountEmailCode:
                    return EduIdError.generateErrorCreateAccountEmailCode(for: statusCode)
                default:
                    return EduIdError.generateError(for: statusCode)
                }
            }
        }
        return EduIdError(title: "Unknown Error", message: "An unknown error occurred.", statusCode: -1)
    }
    
    private static func tryParseResponseError(_ data: Data?, kind: EduIdErrorKind = .regular) -> EduIdError? {
        guard let data else {
            return nil
        }
        let decoder = JSONDecoder()
        let errorResponse = try? decoder.decode(ErrorResponseModel.self, from: data)
        if let title = errorResponse?.error,
           let message = errorResponse?.message,
           let code = errorResponse?.status {
            switch kind {
            case .createAccountEmailCode:
                return EduIdError.generateErrorCreateAccountEmailCode(for: code)
            default:
                return EduIdError(
                    title: title,
                    message: message,
                    statusCode: code
                )
            }
        }
        return nil
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
    
    class ErrorResponseModel: Codable {
        let error: String?
        let message: String?
        let status: Int?
    }
}

extension EduIdError {
    private static func generateErrorCreateAccountEmailCode(for statusCode: Int) -> EduIdError {
        switch statusCode {
        case 400: // Expired. Dead end, need to start again
            return EduIdError(
                title: L.ResponseErrors.EmailCodeError.Title.localization,
                message: L.ResponseErrors.EmailCodeError.Expired.localization,
                statusCode: statusCode
            )
        case 401: // Wrong code. The user can try again
            return EduIdError(
                title: L.ResponseErrors.EmailCodeError.Title.localization,
                message: L.ResponseErrors.EmailCodeError.Incorrect.localization,
                statusCode: statusCode
            )
        case 403: // Rate limited. Dead end
            return EduIdError(
                title: L.ResponseErrors.EmailCodeError.Title.localization,
                message: L.ResponseErrors.EmailCodeError.RateLimited.localization,
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
