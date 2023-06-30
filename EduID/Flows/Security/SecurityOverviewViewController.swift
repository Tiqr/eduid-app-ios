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
        viewModel.dataFetchErrorClosure = {  [weak self] title, message, statusCode in
            guard let self else { return }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L.PinAndBioMetrics.OKButton.localization, style: .default) { _ in
                alert.dismiss(animated: true) {
                    if statusCode == 401 {
                        AppAuthController.shared.authorize(viewController: self)
                        self.dismiss(animated: false)
                        self.refreshDelegate?.requestScreenRefresh(for: .security)
                    } else if statusCode == -1 {
                        self.dismiss(animated: true)
                    }
                }
            })
            self.present(alert, animated: true)
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
                let alert = UIAlertController(
                    title: L.Generic.RequestError.Title.localization,
                    message: L.Generic.RequestError.Description(args: error.localizedDescription).localization,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: L.Generic.RequestError.CloseButton.localization, style: .cancel) { [weak self] _ in
                    guard let self = self else { return }
                    alert.dismiss(animated: true)
                    self.delegate?.dismissSecurityFlow(viewController: self)
                })
                present(alert, animated: true)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissSecurityScreen))
        
        if delegate?.hasPendingPersonalInfo() == true {
            setupUI(personalInfo: delegate?.getAndRemovePendingPersonalInfo()!)
        } else {
            updateData()
        }
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
            text: L.Security.Title.localization,
            size: 24,
            primary:  L.Security.Title.localization
        )
        
        // - create the textView
        let descriptionLabel = UILabel.plainTextLabelPartlyBold(text: L.Security.SubTitle.localization, partBold: "")
        
        let spaceView = UIView()
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        
        
        // - the info controls
        let firstTitle = NSAttributedString(
            string: L.Security.SecondSubTitle.localization,
            attributes: [.font : UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.charcoalColor]
        )
        if let personalInfo = personalInfo {
            
            // 2FA auth keys
            let twoFactorControl: ActionableControlWithBodyAndTitle
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
                twoFactorControl = ActionableControlWithBodyAndTitle(
                    attributedTitle: firstTitle,
                    attributedBodyText: twoFactorText,
                    iconInBody: .shield,
                    isFilled: true,
                    shadow: false
                )
            } else {
                let twoFactorText = NSMutableAttributedString(
                    string: "\(L.Security.TwoFAKey.localization)\n\(L.Security.NotAddedYet.localization)",
                    attributes: [.font: UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.grayGhost])
                twoFactorText.setAttributeTo(
                    part: L.Security.NotAddedYet.localization,
                    attributes: [.font: UIFont.sourceSansProRegular(size: 12), .foregroundColor: UIColor.grayGhost])
                twoFactorControl = ActionableControlWithBodyAndTitle(
                    attributedTitle: firstTitle,
                    attributedBodyText: twoFactorText,
                    iconInBody: .bigPlus,
                    isFilled: false,
                    shadow: true
                )
            }
            
            // Email - magic link
            
            let email = personalInfo.email ?? "?"
            let magicLinkTitle = NSMutableAttributedString(string: "\(L.Security.UseMagicLink.localization)\n\(email)",attributes: [.font: UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.charcoalColor])
            magicLinkTitle.setAttributeTo(part: email, attributes: [.font: UIFont.sourceSansProRegular(size: 12), .foregroundColor: UIColor.charcoalColor])
            let magicLinkControl = ActionableControlWithBodyAndTitle(
                attributedBodyText: magicLinkTitle,
                iconInBody: .pencil.withRenderingMode(.alwaysOriginal),
                isFilled: true,
                shadow: true
            )
            
            // Change or add password
            
            let passwordControl: ActionableControlWithBodyAndTitle
            if personalInfo.usePassword == true {
                let passwordText = NSMutableAttributedString(
                    string: "\(L.Security.ChangePassword.localization)\n\(L.Security.PasswordPlaceholder.localization)",
                    attributes: [.font: UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.charcoalColor])
                passwordText.setAttributeTo(
                    part: L.Security.PasswordPlaceholder.localization,
                    attributes: [.font: UIFont.sourceSansProRegular(size: 12), .foregroundColor: UIColor.charcoalColor])
                passwordControl = ActionableControlWithBodyAndTitle(
                    attributedBodyText: passwordText,
                    iconInBody: .pencil.withRenderingMode(.alwaysOriginal),
                    isFilled: true,
                    shadow: true
                )
            } else {
                let passwordText = NSMutableAttributedString(
                    string: "\(L.Security.AddPassword.localization)\n\(L.Security.NotAddedYet.localization)",
                    attributes: [.font: UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.grayGhost])
                passwordText.setAttributeTo(
                    part: L.Security.NotAddedYet.localization,
                    attributes: [.font: UIFont.sourceSansProRegular(size: 12), .foregroundColor: UIColor.grayGhost])
                passwordControl = ActionableControlWithBodyAndTitle(
                    attributedBodyText: passwordText,
                    iconInBody: .bigPlus,
                    isFilled: false,
                    shadow: true
                )
            }
            
            stack.addArrangedSubview(twoFactorControl)
            stack.addArrangedSubview(magicLinkControl)
            stack.addArrangedSubview(passwordControl)
            twoFactorControl.widthToSuperview()
            magicLinkControl.widthToSuperview()
            passwordControl.widthToSuperview()
            
            // - actions
            twoFactorControl.addTarget(self, action: #selector(goToTwoFactorKeys), for: .touchUpInside)
            magicLinkControl.addTarget(self, action: #selector(enterEmailFlow), for: .touchUpInside)
            passwordControl.addTarget(self, action: #selector(requestPasswordResetLink), for: .touchUpInside)
        } else {
            let loadingIndicator = UIActivityIndicatorView()
            stack.addArrangedSubview(loadingIndicator)
            loadingIndicator.height(80)
            loadingIndicator.startAnimating()
            loadingIndicator.widthToSuperview()
        }
        
        stack.addArrangedSubview(spaceView)
        
        // - create the stackview
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 20
        scrollView.addSubview(stack)
        
        // - add constraints
        stack.width(to: scrollView, offset: -48)
        stack.edges(to: scrollView, insets: .uniform(24))
        titleLabel.width(to: stack)
        descriptionLabel.width(to: stack)
        
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
}
