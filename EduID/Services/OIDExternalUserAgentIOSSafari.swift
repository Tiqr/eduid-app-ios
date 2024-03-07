import UIKit
import AppAuth
import SafariServices
import AuthenticationServices

// MARK: OIDExternalUserAgent
class OIDExternalUserAgentASWebAuthenticationSession: NSObject, OIDExternalUserAgent {
    private let presentingViewController: UIViewController
    private var externalUserAgentFlowInProgress: Bool = false
    private var authenticationViewController: ASWebAuthenticationSession?
    private weak var session: OIDExternalUserAgentSession?

      init(with presentingViewController: UIViewController) {
          self.presentingViewController = presentingViewController
          super.init()
      }

      func present(_ request: OIDExternalUserAgentRequest, session: OIDExternalUserAgentSession) -> Bool {
          if externalUserAgentFlowInProgress {
              return false
          }
          guard let requestURL = request.externalUserAgentRequestURL() else {
              return false
          }
          self.externalUserAgentFlowInProgress = true
          self.session = session

          var openedUserAgent = false

          // ASWebAuthenticationSession doesn't work with guided access (Search web for "rdar://40809553")
          // Make sure that the device is not in Guided Access mode "(Settings -> General -> Accessibility -> Enable Guided Access)"
          if UIAccessibility.isGuidedAccessEnabled == false {
              let redirectScheme = request.redirectScheme()
              let authenticationViewController = ASWebAuthenticationSession(url: requestURL, callbackURLScheme: redirectScheme) { (callbackURL, error) in
                  self.authenticationViewController = nil
                  if let url = callbackURL {
                      self.session?.resumeExternalUserAgentFlow(with: url)
                  } else {
                      let webAuthenticationError = OIDErrorUtilities.error(with: OIDErrorCode.userCanceledAuthorizationFlow,
                                                                           underlyingError: error,
                                                                           description: nil)
                      self.session?.failExternalUserAgentFlowWithError(webAuthenticationError)
                  }
              }
              authenticationViewController.presentationContextProvider = self
              self.authenticationViewController = authenticationViewController
              openedUserAgent = authenticationViewController.start()
          } else {
              let webAuthenticationError = OIDErrorUtilities.error(with: OIDErrorCode.safariOpenError,
                                                                   underlyingError: NSError(domain: OIDGeneralErrorDomain,
                                                                                            code:
                                                                                              OIDErrorCodeOAuth.clientError.rawValue),
                                                                   description: "Device is in Guided Access mode")
              self.session?.failExternalUserAgentFlowWithError(webAuthenticationError)
          }
          return openedUserAgent
      }

      func dismiss(animated: Bool, completion: @escaping () -> Void) {
          // Ignore this call if there is no authorization flow in progress.
          if externalUserAgentFlowInProgress == false {
              completion()
          }
          cleanUp()
          if authenticationViewController != nil {
              authenticationViewController?.cancel()
              completion()
          } else {
              completion()
          }
          return
      }
}

extension OIDExternalUserAgentASWebAuthenticationSession {
    /// Sets class variables to nil. Note 'weak references i.e. session are set to nil to avoid accidentally using them while not in an authorization flow.
    func cleanUp() {
        session = nil
        authenticationViewController = nil
        externalUserAgentFlowInProgress = false
    }
}

extension OIDExternalUserAgentASWebAuthenticationSession: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return presentingViewController.view.window!
    }
}
