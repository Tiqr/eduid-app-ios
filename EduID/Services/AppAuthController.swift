import UIKit
import AppAuth

public class AppAuthController: NSObject {
    
    //MARK: - singleton
    public static var shared = AppAuthController()
    
    //MARK: - properties of AppAuth
    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    private let keychain = KeyChainService()
    private var authState: OIDAuthState? {
        didSet {
            if let state = authState {
                _ = OIDTokenStorage
                    .storeAuthState(state, forService: AppAuthController.clientID)
                    .inspectError { err in
                        NSLog("Failed to store auth state \(err)")
                    }
                state.stateChangeDelegate = self
            } else {
                _ = OIDTokenStorage
                    .removeAuthState(forService: AppAuthController.clientID)
                    .inspectError { err in
                        NSLog("Failed to remove auth state \(err)")
                    }
            }
        }
    }
    var request: OIDAuthorizationRequest!
    var tokenRefreshRequest: OIDTokenRequest {
        let config = OIDServiceConfiguration(
            authorizationEndpoint: URL(string: AppAuthController.authEndpointString)!,
            tokenEndpoint: URL(string: AppAuthController.tokenEndpointString)!
        )
        
        let codeVerifier = OIDAuthorizationRequest.generateCodeVerifier()
        
        return OIDTokenRequest(
            configuration: config,
            grantType: OIDGrantTypeRefreshToken,
            authorizationCode: nil,
            redirectURL: URL(string: AppAuthController.redirectURIString),
            clientID: AppAuthController.clientID,
            clientSecret: nil,
            scope: "eduid.nl/mobile",
            refreshToken: authState?.refreshToken,
            codeVerifier: codeVerifier,
            additionalParameters: nil
        )
    }
    
    //MARK: - URI's
    static let authEndpointString = "https://connect.test2.surfconext.nl/oidc/authorize"
    static let tokenEndpointString = "https://connect.test2.surfconext.nl/oidc/token"
    static let redirectURIString = "https://login.test2.eduid.nl/client/mobile/oauth-redirect"
    public static let clientID = "dev.egeniq.nl"
    
    //MARK: - init
    private override init() {
        super.init()
        
        loadAuthState() { result in
            _ = result.inspectError { error in
                NSLog("Unable to load auth state from storage: \(error)")
            }
        }
        
        let config = OIDServiceConfiguration(
            authorizationEndpoint: URL(string: AppAuthController.authEndpointString)!,
            tokenEndpoint: URL(string: AppAuthController.tokenEndpointString)!
        )
        
        let codeVerifier = OIDAuthorizationRequest.generateCodeVerifier()
        let codeChallenge = OIDAuthorizationRequest.codeChallengeS256(forVerifier: codeVerifier)
        
        request = OIDAuthorizationRequest(
            configuration: config,
            clientId: AppAuthController.clientID,
            clientSecret: nil,
            scope: "eduid.nl/mobile",
            redirectURL: URL(string: AppAuthController.redirectURIString)!,
            responseType: OIDResponseTypeCode,
            state: UUID().uuidString,
            nonce: UUID().uuidString,
            codeVerifier: codeVerifier,
            codeChallenge: codeChallenge,
            codeChallengeMethod: OIDOAuthorizationRequestCodeChallengeMethodS256,
            additionalParameters: nil
        )
        
    }
    
    /// Loads the Auth state.
    /// - Parameter completion: The result of the load operation.
    ///                         After a successful load, the `state` peroperty will be initialized.
    func loadAuthState(completion: @escaping (Result<Void, Error>) -> Void) {
        if let state = try? OIDTokenStorage.getAuthState(forService: AppAuthController.clientID).get() {
            self.authState = state
            completion(.success(()))
            return
        }
    }
    
    public func isRedirectURI(_ uri: URL) -> Bool {
        let expectedRedirectPath = URLComponents(string: AppAuthController.redirectURIString)?.path
        let inputPath = URLComponents(string: uri.absoluteString)?.path
        return expectedRedirectPath != nil &&
            inputPath != nil &&
            inputPath!.caseInsensitiveCompare(expectedRedirectPath!) == .orderedSame
    }
    
    @discardableResult
    public func tryResumeAuthorizationFlow(with uri: URL) -> Bool {
        if let authFlow = currentAuthorizationFlow,
           isRedirectURI(uri) {
            // Normalize URL, because it might be a custom scheme one
            currentAuthorizationFlow = nil
            guard var normalizedUrl = URLComponents(string: uri.absoluteString) else {
                return false
            }
            if normalizedUrl.scheme == "eduid" {
                let expectedUrlComponents = URLComponents(string: AppAuthController.redirectURIString)!
                normalizedUrl.scheme = expectedUrlComponents.scheme
                normalizedUrl.host = expectedUrlComponents.host
            }
            return authFlow.resumeExternalUserAgentFlow(with: normalizedUrl.url!)
        } else {
            currentAuthorizationFlow = nil
            return false
        }
    }
    
    public func isLoggedIn() -> Bool {
        return authState != nil
    }
    
    public func authorize(viewController: UIViewController, completion: (() -> Void)? = nil) {
        let externalUserAgent = OIDExternalUserAgentIOSSafari(presentingViewController: viewController)
        currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, externalUserAgent: externalUserAgent) {
            [weak self] authState, error in
            guard let self else { return }
            if let authState = authState {
                self.authState = authState
                completion?()
            } else {
                fatalError("authorization failed")
            }
        }
    }
    
    public func performWithFreshTokens(completion: @escaping((String?) -> Void)) {
        if authState == nil {
            completion(nil)
        } else {
            authState!.performAction(freshTokens: { accessToken, idToken, error in
                if let error = error {
                    NSLog("Could not refresh tokens: \(error)")
                }
                completion(accessToken)
            })
        }
    }
    
    /// Ends user session by clearing the auth state
    public func clearAuthState() {
       self.authState = nil
   }
    
}


extension AppAuthController: OIDAuthStateChangeDelegate {
    // Handle state changes when token is refreshed or invalidated.
    public func didChange(_ state: OIDAuthState) {
        self.authState = state
    }
}
