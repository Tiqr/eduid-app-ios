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
    
    init(viewModel: SecurityOverviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI(personalInfo: nil)
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
                    self.delegate?.securityViewControllerDismissSecurityFlow(viewController: self)
                })
                present(alert, animated: true)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissSecurityScreen))
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
            if ServiceContainer.sharedInstance().identityService.identityCount() > 0 {
                // TODO use correct identity here
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
                    iconInBody: .pencil.withRenderingMode(.alwaysTemplate),
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
            
            // Sign-in settings
            
            let signInSettingsTitle = NSAttributedString(
                string: L.Security.SignInSettings.localization,
                attributes: [.font : UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.charcoalColor])
            let signInSettingsBodyText = NSMutableAttributedString(
                string: L.Security.SettingRememberMe.Title.localization,
                attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.charcoalColor])
            signInSettingsBodyText.setAttributeTo(
                part: L.Security.SettingRememberMe.BoldPart.localization,
                attributes: [.font: UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.charcoalColor])
            let signInSettingsControl = ActionableControlWithBodyAndTitle(attributedTitle: signInSettingsTitle, attributedBodyText: signInSettingsBodyText, iconInBody: UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate), isFilled: true, shadow: true)
            
            stack.addArrangedSubview(twoFactorControl)
            stack.addArrangedSubview(magicLinkControl)
            stack.addArrangedSubview(passwordControl)
            stack.addArrangedSubview(signInSettingsControl)
            twoFactorControl.widthToSuperview()
            magicLinkControl.widthToSuperview()
            passwordControl.widthToSuperview()
            signInSettingsControl.widthToSuperview()
            
            // - actions
            magicLinkControl.addTarget(self, action: #selector(enterEmailFlow), for: .touchUpInside)
            passwordControl.addTarget(self, action: #selector(enterChangePasswordFlow), for: .touchUpInside)
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
        delegate?.securityViewControllerDismissSecurityFlow(viewController: self)
    }
    
    @objc
    func enterEmailFlow() {
        delegate?.securityViewControllerEnterVerifyEmailFlow(viewController: self)
    }
    
    @objc
    func enterChangePasswordFlow() {
        delegate?.securityViewControllerEnterChangePasswordFlow(viewController: self)
    }
}
