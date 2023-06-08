import Foundation
import OpenAPIClient

class BearerRequestBuilderFactory: RequestBuilderFactory {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type {
        BearerRequestBuilder<T>.self
    }

    func getBuilder<T: Decodable>() -> RequestBuilder<T>.Type {
        BearerDecodableRequestBuilder<T>.self
    }
}

class BearerRequestBuilder<T>: URLSessionRequestBuilder<T> {
    @discardableResult
    override func execute(_ apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, _ completion: @escaping (Result<Response<T>, ErrorResponse>) -> Void) -> RequestTask {
        // Before making the request, we make sure that all our tokens are up-to-date
        BearerTokenHandler.performWithFreshTokens {
            // Here we make the request
            super.execute(apiResponseQueue) { result in
                completion(result)
            }
        }
        return requestTask
    }
}

class BearerDecodableRequestBuilder<T: Decodable>: URLSessionDecodableRequestBuilder<T> {
    @discardableResult
    override func execute(_ apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, _ completion: @escaping (Result<Response<T>, ErrorResponse>) -> Void) -> RequestTask {
        // Before making the request, we make sure that all our tokens are up-to-date
        BearerTokenHandler.performWithFreshTokens {
            // Here we make the request
            super.execute(apiResponseQueue) { result in
                completion(result)
            }
        }
        return requestTask
    }
}

class BearerTokenHandler {
    
    static func performWithFreshTokens(completionHandler: @escaping () -> Void) {
        AppAuthController.shared.performWithFreshTokens { accessToken in
            if let accessToken = accessToken {
                OpenAPIClientAPI.customHeaders[Constants.Headers.authorization] = "Bearer \(accessToken)"
            } else {
                OpenAPIClientAPI.customHeaders[Constants.Headers.authorization] = ""
            }
            completionHandler()
        }
    }
}
