import UIKit
import TinyConstraints
import OpenAPIClient
import TiqrCoreObjC

class SecurityOverviewViewController: UIViewController, ScreenWithScreenType {
    
    // - screen type
    var screenType: ScreenType = .securityOverviewScreen
    
    private let viewModel: SecurityOverviewViewModel
    
    // - delegate
    weak var delegate: SecurityViewControllerDelegate?
    weak var refreshDelegate: RefreshChildScreenDelegate?
    
    init(viewModel: SecurityOverviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.dataFetchErrorClosure = {  [weak self] eduidError in
            guard let self else { return }
            if eduidError.statusCode == 401 {
                requestRefreshToken()
            } else if eduidError.statusCode == -1 {
                self.dismiss(animated: true)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI(personalInfo: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForeground() {
        updateData()
    }
    
    private func updateData() {
        Task {
            do {
                let personalInfo = try await viewModel.getData()
                setupUI(personalInfo: personalInfo)
            } catch {
                requestRefreshToken()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissSecurityScreen))
        requestRefreshToken()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - setup UI
    func setupUI(personalInfo: UserResponse?) {
        view.subviews.forEach { $0.removeFromSuperview() }
        // - scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        // - posterLabel
        let titleLabel = UILabel.posterTextLabelBicolor(
            text: L.Security.Title.localization + "\n" + L.Security.SubTitle.localization,
            size: 24,
            primary:  L.Security.Title.localization
        )
        
        let chevronImage = UIImage(systemName: "chevron.right")!
                
        let stack = UIStackView(arrangedSubviews: [titleLabel])
        
        var otherMethodsString: NSAttributedString? = NSAttributedString(
            string: L.Security.OtherMethods.localization,
            attributes: [.font : UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.secondaryColor]
        )
        
        var hasTwoFactorKey: Bool = false
        var hasPassword: Bool = false
        
        if let personalInfo = personalInfo {
            // 2FA auth keys
            let identity = ServiceContainer.sharedInstance().identityService.findIdentity(withIdentifier: personalInfo.id)
            if let identity = identity {
                let identityProvider = identity.identityProvider.displayName ?? identity.identityProvider.identifier ?? "?"
                let providedBy = "\(L.Security.ProvidedBy.localization) \(identityProvider)"
                let twoFactorText = NSMutableAttributedString(
                    string: "\(L.Security.TwoFAKey.localization)\n\(providedBy)",
                    attributes: [.font: UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.backgroundColor])
                twoFactorText.setAttributeTo(
                    part: L.Security.ProvidedBy.localization,
                    attributes: [.font: UIFont.sourceSansProRegular(size: 12), .foregroundColor: UIColor.grayGhost])
                twoFactorText.setAttributeTo(
                    part: identityProvider,
                    attributes: [.font: UIFont.sourceSansProSemiBold(size: 12), .foregroundColor: UIColor.grayGhost])
                let twoFactorControl = ActionableControlWithBodyAndTitle(
                    attributedTitle: nil,
                    attributedBodyText: twoFactorText,
                    leftIcon: .securityKey.withRenderingMode(.alwaysOriginal).withTintColor(.backgroundColor),
                    rightIcon: chevronImage.withRenderingMode(.alwaysOriginal).withTintColor(.backgroundColor),
                    isFilled: true
                )
                stack.addArrangedSubview(twoFactorControl)
                twoFactorControl.addTarget(self, action: #selector(goToTwoFactorKeys), for: .touchUpInside)
                twoFactorControl.widthToSuperview()
                hasTwoFactorKey = true
            }
            
            // eduID mobile app - shown when the user has registered/linked the eduID mobile app as a login option
            if let appService = personalInfo.eduIdPerServiceProvider?.values.first(where: { $0.serviceName == "eduID mobile app" }) {
                let appName = appService.serviceName ?? "?"
                let appSubtitle: String
                if let createdAt = appService.createdAt {
                    let createdAtDate = Date(timeIntervalSince1970: Double(createdAt / 1000))
                    let dateString = VerifiedInformationControlCollapsible.dateFormatter.string(from: createdAtDate)
                    appSubtitle = L.Security.PasswordActivated(args: dateString).localization
                } else {
                    appSubtitle = ""
                }
                let appText = NSMutableAttributedString(
                    string: "\(appName)\n\(appSubtitle)",
                    attributes: [.font: UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.backgroundColor])
                appText.setAttributeTo(
                    part: appSubtitle,
                    attributes: [.font: UIFont.sourceSansProRegular(size: 12), .foregroundColor: UIColor.grayGhost])
                let appControl = ActionableControlWithBodyAndTitle(
                    attributedBodyText: appText,
                    leftIcon: UIImage.phone.withRenderingMode(.alwaysOriginal).withTintColor(.backgroundColor),
                    rightIcon: nil,
                    isFilled: true
                )
                stack.addArrangedSubview(appControl)
                appControl.widthToSuperview()
            }
            
            // Change or add password
            if personalInfo.usePassword == true {
                let passwordSubtitle: String
                if let passwordUpdatedAt = personalInfo.passwordUpdatedAt {
                    let passwordUpdatedAtDate = Date(timeIntervalSince1970: Double(passwordUpdatedAt / 1000))
                    let dateString = VerifiedInformationControlCollapsible.dateFormatter.string(from: passwordUpdatedAtDate)
                    passwordSubtitle = L.Security.PasswordActivated(args: dateString).localization
                } else {
                    passwordSubtitle = L.Security.PasswordPlaceholder.localization
                }
                let passwordText = NSMutableAttributedString(
                    string: "\(L.Security.ChangePassword.localization)\n\(passwordSubtitle)",
                    attributes: [.font: UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.backgroundColor])
                passwordText.setAttributeTo(
                    part: passwordSubtitle,
                    attributes: [.font: UIFont.sourceSansProRegular(size: 12), .foregroundColor: UIColor.grayGhost])
                let passwordControl = ActionableControlWithBodyAndTitle(
                    attributedBodyText: passwordText,
                    leftIcon: .password.withRenderingMode(.alwaysOriginal).withTintColor(.backgroundColor),
                    rightIcon: chevronImage.withRenderingMode(.alwaysOriginal).withTintColor(.backgroundColor),
                    isFilled: true
                )
                stack.addArrangedSubview(passwordControl)
                passwordControl.widthToSuperview()
                passwordControl.addTarget(self, action: #selector(requestPasswordResetLink), for: .touchUpInside)
                hasPassword = true
            }
            
            // Email - magic link
            let email = personalInfo.email ?? "?"
            let magicLinkTitle = NSMutableAttributedString(string: "\(L.Security.UseCode.localization)\n\(email)",attributes: [.font: UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.backgroundColor])
            magicLinkTitle.setAttributeTo(part: email, attributes: [.font: UIFont.sourceSansProRegular(size: 12), .foregroundColor: UIColor.grayGhost])
            let magicLinkControl = ActionableControlWithBodyAndTitle(
                attributedBodyText: magicLinkTitle,
                leftIcon: .magicLink.withRenderingMode(.alwaysOriginal).withTintColor(.backgroundColor),
                rightIcon: chevronImage.withRenderingMode(.alwaysOriginal).withTintColor(.backgroundColor),
                isFilled: true
            )
            stack.addArrangedSubview(magicLinkControl)
            magicLinkControl.widthToSuperview()
            magicLinkControl.addTarget(self, action: #selector(enterEmailFlow), for: .touchUpInside)
            
            // Passkeys - not usable on mobile, but must be visible so they can be managed via the browser
            for passkey in personalInfo.publicKeyCredentials ?? [] {
                let name = passkey.name ?? "?"
                let dateString: String
                if let createdAt = passkey.createdAt {
                    let createdAtDate = Date(timeIntervalSince1970: Double(createdAt / 1000))
                    dateString = VerifiedInformationControlCollapsible.dateFormatter.string(from: createdAtDate)
                } else {
                    dateString = "?"
                }
                let credentialSubtitle = L.Security.CredentialActivated(args: name, dateString).localization
                let passkeyText = NSMutableAttributedString(
                    string: "\(L.Security.Passkey.localization)\n\(credentialSubtitle)",
                    attributes: [.font: UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.backgroundColor])
                passkeyText.setAttributeTo(
                    part: credentialSubtitle,
                    attributes: [.font: UIFont.sourceSansProRegular(size: 12), .foregroundColor: UIColor.grayGhost])
                let passkeyControl = ActionableControlWithBodyAndTitle(
                    attributedBodyText: passkeyText,
                    leftIcon: .securityKey.withRenderingMode(.alwaysOriginal).withTintColor(.backgroundColor),
                    rightIcon: nil,
                    isFilled: true
                )
                stack.addArrangedSubview(passkeyControl)
                passkeyControl.widthToSuperview()
            }
            
            if !hasTwoFactorKey && false { // Disabled on purpose - adding a security key is not possible yet. See TIQR-450 for more info.
                let twoFactorText = NSMutableAttributedString(
                    string: (L.Security.TwoFAKey.localization),
                    attributes: [.font: UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.grayGhost])
                let twoFactorControl = ActionableControlWithBodyAndTitle(
                    attributedTitle: otherMethodsString,
                    attributedBodyText: twoFactorText,
                    leftIcon: .securityKey.withRenderingMode(.alwaysOriginal).withTintColor(.grayGhost),
                    rightIcon: .bigPlus.withRenderingMode(.alwaysOriginal).withTintColor(.grayGhost),
                    isFilled: false
                )
                stack.addArrangedSubview(twoFactorControl)
                twoFactorControl.addTarget(self, action: #selector(goToTwoFactorKeys), for: .touchUpInside)
                twoFactorControl.widthToSuperview()
                otherMethodsString = nil
            }
            if !hasPassword {
                let passwordText = NSMutableAttributedString(
                    string: L.Security.AddPassword.localization,
                    attributes: [.font: UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.grayGhost])
                let passwordControl = ActionableControlWithBodyAndTitle(
                    attributedTitle: otherMethodsString,
                    attributedBodyText: passwordText,
                    leftIcon: .password.withRenderingMode(.alwaysOriginal).withTintColor(.grayGhost),
                    rightIcon: .bigPlus.withRenderingMode(.alwaysOriginal).withTintColor(.grayGhost),
                    isFilled: false
                )
                stack.addArrangedSubview(passwordControl)
                passwordControl.widthToSuperview()
                passwordControl.addTarget(self, action: #selector(requestPasswordResetLink), for: .touchUpInside)
            }
            
            // Recovery options - SMS
            if let phoneNumber = personalInfo.registration?["phoneNumber"]?.value as? String, !phoneNumber.isEmpty {
                let recoveryOptionsTitle = NSAttributedString(
                    string: L.Security.RecoveryOptions.localization,
                    attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.secondaryColor]
                )
                let smsSubtitle = L.Security.ReceiveCodeAt(args: phoneNumber).localization
                let smsText = NSMutableAttributedString(
                    string: "\(L.Security.SMS.localization)\n\(smsSubtitle)",
                    attributes: [.font: UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.backgroundColor])
                smsText.setAttributeTo(
                    part: smsSubtitle,
                    attributes: [.font: UIFont.sourceSansProRegular(size: 12), .foregroundColor: UIColor.grayGhost])
                let smsControl = ActionableControlWithBodyAndTitle(
                    attributedTitle: recoveryOptionsTitle,
                    attributedBodyText: smsText,
                    leftIcon: UIImage.phone.withRenderingMode(.alwaysOriginal).withTintColor(.backgroundColor),
                    rightIcon: nil,
                    isFilled: true
                )
                stack.addArrangedSubview(smsControl)
                smsControl.widthToSuperview()
            }
        } else {
            let loadingIndicator = UIActivityIndicatorView()
            stack.addArrangedSubview(loadingIndicator)
            loadingIndicator.height(80)
            loadingIndicator.startAnimating()
            loadingIndicator.widthToSuperview()
        }
        
        
        // - create the stackview
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 20
        stack.setCustomSpacing(32, after: titleLabel)
        scrollView.addSubview(stack)
        
        // - add constraints
        stack.width(to: scrollView, offset: -48)
        stack.edges(to: scrollView, insets: .uniform(24))
        titleLabel.width(to: stack)
        
    }
    
    @objc
    func dismissSecurityScreen() {
        delegate?.dismissSecurityFlow(viewController: self)
    }
    
    @objc
    func goToTwoFactorKeys() {
        delegate?.goToTwoFactorKeys(viewModel.personalInfo!)
    }
    
    @objc
    func enterEmailFlow() {
        delegate?.goToVerifyEmailFlow(viewController: self)
    }
    
    @objc
    func requestPasswordResetLink() {
        delegate?.requestPasswordResetLink(viewController: self, personalInfo: viewModel.personalInfo!)
    }
    
    private func requestRefreshToken() {
        AppAuthController.shared.performWithFreshTokens(completion: { [weak self] _ in
            guard let self else { return }
            self.updateData()
        })
        self.refreshDelegate?.requestScreenRefresh(for: .security)
    }
}
