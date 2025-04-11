import UIKit
import AppAuth

class OIDExternalUserAgentUsingWebViewController: NSObject {
    var _navigationController: UINavigationController!
    var _registrationURL: URL? = nil
    var _externalUserAgentFlowInProgress: Bool = false
    weak var _session: OIDExternalUserAgentSession?

    /**
     Unavailable. Please use initWithPresentingViewController:
     */
    @available(*, unavailable, message: "Please use initWithPresentingViewController")

    override init() {
        fatalError("Unavailable. Please use initWithPresentingViewController")
    }

    /**
     The designated initializer.
     - Parameter presentingViewController: The view controller from which to present the SFSafariViewController.
     */
    required init(
        navigationController: UINavigationController,
        registrationURL: URL?
    ) {
        super.init()
        self._navigationController = navigationController
        self._registrationURL = registrationURL
    }

    func cleanUp() {
        _session = nil
        _externalUserAgentFlowInProgress = false
    }
}

// MARK: OIDExternalUserAgent
extension OIDExternalUserAgentUsingWebViewController: OIDExternalUserAgent {
    func present(_ request: OIDExternalUserAgentRequest, session: OIDExternalUserAgentSession) -> Bool {
        if _externalUserAgentFlowInProgress {
            return false
        }

        _externalUserAgentFlowInProgress = true
        _session = session

        
        if let requestURL = request.externalUserAgentRequestURL() {
            let webViewController = WebViewController(startURL: requestURL, registrationURL: _registrationURL)
            webViewController.modalPresentationStyle = .pageSheet
            if #available(iOS 15.0, *),
               let sheet = _navigationController.sheetPresentationController {
                sheet.detents = [.large()]
            }
            let wrappingNavController = UINavigationController(rootViewController: webViewController)
            _navigationController.present(wrappingNavController, animated: true)
            return true
        } else {
            self.cleanUp()
            return false
        }
    }


    func dismiss(animated: Bool, completion: @escaping () -> Void) {
        if !_externalUserAgentFlowInProgress {
            // Ignore this call if there is no authorization flow in progress.
            return
        }
        
        if _navigationController.presentedViewController is WebViewController ||
            (_navigationController.presentedViewController is UINavigationController &&
             (_navigationController.presentedViewController as! UINavigationController).topViewController is WebViewController) {
            _navigationController.dismiss(animated: true)
        }

        completion()

        self.cleanUp()

        return
    }
}
