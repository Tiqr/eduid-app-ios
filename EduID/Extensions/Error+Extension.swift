import Foundation
import OpenAPIClient

extension Error {
    func eduIdResponseError()->(title: String, message: String) {
        if let response = self as? ErrorResponse {
            switch response {
            case let .error(statusCode, _, _, _):
                switch statusCode {
                case 403:
                    return (title: L.ResponseErrors.SMSErrorTitle.localization,
                            message: L.ResponseErrors.SMSErrorText.localization)
                case 409:
                    return (title: L.ResponseErrors.EmailInUseTitle.localization,
                            message: L.ResponseErrors.EmailInUseText.localization)
                case 412:
                    return (title: L.ResponseErrors.ForbiddenDomainTitle.localization,
                            message: L.ResponseErrors.ForbiddenDomainText.localization)
                default:
                    return (title: "\(statusCode) \(L.ResponseErrors.UnknownErrorTitle.localization)",
                            message: L.ResponseErrors.UnknownErrorText.localization)
                }
            }
        }
        return (title: "",message: "")
    }
}
