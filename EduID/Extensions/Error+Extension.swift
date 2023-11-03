import Foundation
import OpenAPIClient

extension Error {
    func eduIdResponseError() -> (title: String, message: String, statusCode: Int) {
        if let response = self as? ErrorResponse {
            switch response {
            case let .error(statusCode, _, _, _):
                switch statusCode {
                case 401:
                    return (title: L.ResponseErrors.UnauthorizedTitle.localization,
                            message: L.ResponseErrors.UnauthorizedText.localization,
                            statusCode: statusCode)
                case 403:
                    return (title: L.ResponseErrors.SMSErrorTitle.localization,
                            message: L.ResponseErrors.SMSErrorText.localization,
                            statusCode: statusCode)
                case 409:
                    return (title: L.ResponseErrors.EmailInUseTitle.localization,
                            message: L.ResponseErrors.EmailInUseText.localization,
                            statusCode: statusCode)
                case 412:
                    return (title: L.ResponseErrors.ForbiddenDomainTitle.localization,
                            message: L.ResponseErrors.ForbiddenDomainText.localization,
                            statusCode: statusCode)
                case -1:
                    return (title: L.ResponseErrors.NoInternetAccessTitle.localization,
                            message: L.ResponseErrors.NoInternetAccessText.localization,
                            statusCode: statusCode)
                    
                default:
                    return (title: "\(statusCode) \(L.ResponseErrors.NoInternetAccessTitle.localization)",
                            message: "\(L.ResponseErrors.UnknownErrorText.localization) \(statusCode)",
                            statusCode: statusCode)
                }
            }
        }
        return (title: "",message: "", .zero)
    }
}
