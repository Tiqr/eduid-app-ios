//
//  WebViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2024. 11. 28..
//
import WebKit
import TinyConstraints
import NotificationCenter

protocol WebViewControllerDelegate: AnyObject {
    func webViewControllerDidFinish(_ webViewController: WebViewController, with alreadyVerifyAlreadyUsedEmail: String?)
}

class WebViewController: BaseViewController {
    
    var startURL: URL!
    var isRegistrationFlow = false
    
    private var webView: WKWebView!
    private var dontInterceptNextNavigation = false
    weak var webViewControllerDelegate: WebViewControllerDelegate?
    
    required init(startURL: URL) {
        self.startURL = startURL
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .webView
        
        self.view.backgroundColor = .white
        self.webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        webView.edgesToSuperview(usingSafeArea: true)
        webView.load(URLRequest(url: startURL))
        webView.navigationDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onMagicLinkOpened), name: .onMagicLinkOpened, object: nil)
    }
    
    @objc
    func onMagicLinkOpened(_ notification: NSNotification) {
        guard let url = notification.userInfo?[Constants.UserInfoKey.magicLinkUrl] as? URL else {
            assertionFailure("No magic link URL property sent in the notification!")
            return
        }
        // Navigate to the URL in our browser
        dontInterceptNextNavigation = true
        self.webView.load(URLRequest(url: url))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.backgroundColor
        navigationController?.setNavigationBarHidden(false, animated: true)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissInfoScreen))
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func dismissInfoScreen() {
        _ = self.navigationController?.dismiss(animated: true)
    }
}


extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if dontInterceptNextNavigation {
                dontInterceptNextNavigation = false
                decisionHandler(.allow)
                return
            }
            if AppAuthController.shared.isRedirectURI(url) {
                decisionHandler(.cancel)
                AppAuthController.shared.tryResumeAuthorizationFlow(with: url)
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first(where: { $0.activationState == .foregroundActive })?.delegate as? SceneDelegate {
                    sceneDelegate.userDidFinishAuthentication()
                }
                return
            } else if url.absoluteString.contains("eduid.nl/login/") && isRegistrationFlow {
                // Navigate from login to registration
                decisionHandler(.cancel)
                let previousUrl = url.absoluteString
                let modifiedUrl = previousUrl.replacingOccurrences(of: "/login/", with: "/request/")
                webView.load(URLRequest(url: URL(string: modifiedUrl)!))
                return
            } else {
                guard let scenedelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                    return
                }
                let urlResult = extractPathSegmentAndEmail(from: url.absoluteString)
                guard urlResult.pathSegment != "verify-already-used" else {
                    webViewControllerDelegate?.webViewControllerDidFinish(self, with: urlResult.email)
                    decisionHandler(.cancel)
                    dismissInfoScreen()
                    return
                }
                if isAppHost(url) && scenedelegate.handleURLFromRedirect(url: url) {
                    decisionHandler(.cancel)
                    dismissInfoScreen()
                    return
                }
            }
        }
        decisionHandler(.allow)
    }
    
    func isAppHost(_ url: URL) -> Bool {
        let appHost = URL(string: EnvironmentService.shared.currentEnvironment.baseUrl)!.host
        return url.host == appHost
    }
    
    func extractPathSegmentAndEmail(from urlString: String) -> (pathSegment: String?, email: String?) {
        guard let urlComponents = URLComponents(string: urlString) else {
            return (nil, nil)
        }
        
        let pathSegments = urlComponents.path.components(separatedBy: "/")
        let targetSegment = pathSegments.first { $0 == "verify-already-used" }
        
        let emailParam = urlComponents.queryItems?.first { $0.name == "email" }?.value
        let decodedEmail = emailParam?.removingPercentEncoding
        
        return (targetSegment, decodedEmail)
    }
}

