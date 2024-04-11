import UIKit
import TinyConstraints

class PersonalInfoViewController: UIViewController, ScreenWithScreenType {
    
    // - screen type
    var screenType: ScreenType = .personalInfoLandingScreen
    
    // - delegate
    weak var delegate: PersonalInfoViewControllerDelegate?
    
    private var viewModel: PersonalInfoViewModel
    
    private var stack: UIStackView!
    private var addInstitutionButton: ActionableControlWithBodyAndTitle!
    private var verifyIdentityLoadingIndicator: UIActivityIndicatorView!
    weak var refreshDelegate: RefreshChildScreenDelegate?
    
    static var indexOfFirstLinkedAccount = 5
    
    //MARK: - init
    init(viewModel: PersonalInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.dataAvailableClosure = { [weak self] model in
            self?.setupUI(model: model)
        }
        
        viewModel.serviceRemovedClosure = { [weak self] account in
            let views = self?.stack.arrangedSubviews.filter { view in
                (view as? InstitutionControlCollapsible)?.institution == account.schacHomeOrganization
            } as? [UIView] ?? []
            UIView.animate(withDuration: 0.2, delay: 0, animations: {
                views.forEach { view in
                    view.isHidden = true
                }
            }) { [weak self] _ in
                views.forEach { view in
                    self?.stack.removeArrangedSubview(view)
                }
            }
        }
        
        viewModel.dataFetchErrorClosure = { [weak self] title, message, statusCode in
            guard let self else { return }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L.PinAndBioMetrics.OKButton.localization, style: .default) { _ in
                alert.dismiss(animated: true) {
                    if statusCode == 401 {
                        AppAuthController.shared.authorize(viewController: self)
                        self.dismiss(animated: false)
                        self.refreshDelegate?.requestScreenRefresh(for: .personalInfo)
                    } else if statusCode == -1 {
                        self.dismiss(animated: true)
                    }
                }
            })
            self.present(alert, animated: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLinkingErrorScreen), name: .accountAlreadyLinked, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI(model: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForeground() {
        viewModel.getData()
    }
    
    @objc
    func showLinkingErrorScreen(_ notification: NSNotification) {
        // User tried to link account, but it was already linked
        let linkedAccountEmail = notification.userInfo?[Constants.UserInfoKey.linkedAccountEmail] as? String
        delegate?.goToAccountLinkingErrorScreen(linkedAccountEmail: linkedAccountEmail)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        if delegate?.shouldUpdateData() == true {
            viewModel.getData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getData()
    }
    
    //MARK: - setup UI
    func setupUI(model: PersonalInfoDataCallbackModel?) {
        // Try to remember scroll position
        var previousScrollPosition: CGFloat = 0
        // Remove any previous views
        view.subviews.forEach {
            if let scrollView = $0 as? UIScrollView {
                previousScrollPosition = scrollView.contentOffset.y
            }
            $0.removeFromSuperview()
        }
        // - scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
        view.addSubview(scrollView)
        scrollView.edgesToSuperview()

        // - Main title
        let mainTitle = UILabel.posterTextLabelBicolor(text: L.Profile.Title.localization, size: 24, primary:  L.Profile.Title.localization)
        
        // - Description below title
        let mainDescriptionParent = UIView()
        let mainDescription = UILabel.plainTextLabelPartlyBold(text: L.Profile.Info.localization, partBold: "")
        mainDescriptionParent.addSubview(mainDescription)
        mainDescription.edges(to: mainDescriptionParent)
        
        // Your identity header
        let yourIdentityContainer = UIView()
        let yourIdentityHeader = UILabel()
        let yourIdentityString = NSAttributedString(
            string: L.Profile.YourIdentity.localization,
            attributes: AttributedStringHelper.attributes(
                font: UIFont.nunitoBold(size: 22),
                color: .primaryColor,
                lineSpacing: 10)
        )
        yourIdentityHeader.attributedText = yourIdentityString
        yourIdentityContainer.addSubview(yourIdentityHeader)
        yourIdentityHeader.edgesToSuperview()
        
        
        // - create the stackview
        stack = UIStackView(arrangedSubviews: [mainTitle, mainDescriptionParent, yourIdentityContainer])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        scrollView.addSubview(stack)
        
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 0, bottom: 0, right: 0))
        stack.width(to: scrollView, offset: 0)
        
        mainTitle.widthToSuperview(offset: -48)
        mainDescriptionParent.widthToSuperview(offset: -48)
        yourIdentityContainer.widthToSuperview(offset: -48)
        
        // Unverified disclaimer (if not verified yet)
        let linkedAccounts = model?.userResponse.linkedAccounts
        
        if model?.userResponse != nil && linkedAccounts?.isEmpty != false {
            let disclaimerShieldImage = UIImageView(image: .shield)
            disclaimerShieldImage.size(CGSize(width: 24, height: 28))
            let disclaimerTitle = UILabel()
            disclaimerTitle.text = L.Profile.VerifyNow.Title.localization
            disclaimerTitle.numberOfLines = 0
            disclaimerTitle.textColor = .textColor
            disclaimerTitle.font = .sourceSansProSemiBold(size: 16)
            let disclaimerButtonContainer = UIView()
            disclaimerButtonContainer.size(CGSize(width: 250, height: 40))
            let disclaimerButton = EduIDButton(type: .empty, buttonTitle: L.Profile.VerifyNow.Button.localization, frame: CGRect(origin: .zero, size: CGSize(width: 250, height: 40)))
            disclaimerButtonContainer.addSubview(disclaimerButton)
            disclaimerButton.edgesToSuperview()
            verifyIdentityLoadingIndicator = UIActivityIndicatorView()
            verifyIdentityLoadingIndicator.size(CGSize(width: 32, height: 32))
            disclaimerButtonContainer.addSubview(verifyIdentityLoadingIndicator)
            verifyIdentityLoadingIndicator.rightToSuperview(offset: -8)
            verifyIdentityLoadingIndicator.centerYToSuperview()
            verifyIdentityLoadingIndicator.isHidden = true
            let disclaimerTextStack = UIStackView(arrangedSubviews: [disclaimerTitle, disclaimerButtonContainer])
            disclaimerTextStack.axis = .vertical
            disclaimerTextStack.alignment = .leading
            disclaimerTextStack.spacing = 12
            disclaimerTextStack.distribution = .fill
            let disclaimerContainer = UIStackView(arrangedSubviews: [disclaimerShieldImage, disclaimerTextStack])
            disclaimerContainer.axis = .horizontal
            disclaimerContainer.alignment = .leading
            disclaimerContainer.spacing = 12
            disclaimerContainer.distribution = .fill
            disclaimerContainer.backgroundColor = .lightBackgroundColor
            stack.insertArrangedSubview(disclaimerContainer, at: 2)
            disclaimerContainer.isLayoutMarginsRelativeArrangement = true
            disclaimerContainer.layoutMargins = .horizontal(24) + .vertical(12)
            disclaimerContainer.widthToSuperview()
            disclaimerButton.addTarget(self, action: #selector(verifyIdentityClicked), for: .touchUpInside)
            // Add unverified badge
            let unverifiedBadge = UIView()
            unverifiedBadge.backgroundColor = .lightGray
            unverifiedBadge.height(24)
            unverifiedBadge.layer.cornerRadius = 5.2
            let unverifiedLabel = UILabel()
            unverifiedLabel.text = L.Profile.NotVerified.localization.lowercased()
            unverifiedLabel.textColor = .grayGhost
            unverifiedLabel.font = .nunitoBold(size: 12)
            unverifiedBadge.addSubview(unverifiedLabel)
            unverifiedLabel.edgesToSuperview(insets: .horizontal(12))
            yourIdentityContainer.addSubview(unverifiedBadge)
            unverifiedBadge.rightToSuperview()
            unverifiedBadge.centerYToSuperview()
        } else {
            // Add verified badge
            let verifiedBadge = UIView()
            let verifiedCheckmark = UIImageView()
            verifiedCheckmark.size(CGSize(width: 13, height: 12))
            verifiedCheckmark.image = .verifiedCheckmark.withRenderingMode(.alwaysTemplate)
            verifiedCheckmark.tintColor = .white
            verifiedBadge.addSubview(verifiedCheckmark)
            verifiedCheckmark.centerYToSuperview()
            verifiedCheckmark.leftToSuperview(offset: 6)
            verifiedBadge.backgroundColor = .primaryColor
            verifiedBadge.height(24)
            verifiedBadge.layer.cornerRadius = 5.2
            let verifiedLabel = UILabel()
            verifiedLabel.text = L.Profile.Verified.localization.lowercased()
            verifiedLabel.textColor = .white
            verifiedLabel.font = .nunitoBold(size: 12)
            verifiedBadge.addSubview(verifiedLabel)
            verifiedLabel.edgesToSuperview(excluding: .left, insets: .horizontal(12))
            verifiedLabel.leftToRight(of: verifiedCheckmark, offset: 6)
            yourIdentityContainer.addSubview(verifiedBadge)
            verifiedBadge.rightToSuperview()
            verifiedBadge.centerYToSuperview()
        }
        
        // Info controls
        if let model = model {
            // First name
            if let firstName = model.firstName {
                let firstNameSubtitleText = NSMutableAttributedString()
                firstNameSubtitleText.append(NSAttributedString(
                    string: "\(firstName)\n",
                    attributes: AttributedStringHelper.attributes(
                        font: .sourceSansProSemiBold(size: 16),
                        color: .backgroundColor,
                        lineSpacing: 6
                    ))
                )
                firstNameSubtitleText.append(NSAttributedString(
                    string: "\(L.Profile.FirstName.localization) ",
                    attributes: AttributedStringHelper.attributes(
                        font: .sourceSansProRegular(size: 12),
                        color: .grayGhost,
                        lineSpacing: 6
                    ))
                )
                let firstNameControl = ActionableControlWithBodyAndTitle(
                    attributedTitle: nil,
                    attributedBodyText: firstNameSubtitleText,
                    iconInBody: .pencil.withRenderingMode(.alwaysTemplate),
                    isFilled: true
                )
                stack.addArrangedSubview(firstNameControl)
                firstNameControl.widthToSuperview(offset: -48)
                firstNameControl.addTarget(self, action: #selector(nameControlClicked), for: .touchUpInside)
            }
            
            if let lastName = model.lastName {
                let lastNameSubtitleText = NSMutableAttributedString()
                lastNameSubtitleText.append(NSAttributedString(
                    string: "\(lastName)\n",
                    attributes: AttributedStringHelper.attributes(
                        font: .sourceSansProSemiBold(size: 16),
                        color: .backgroundColor,
                        lineSpacing: 6
                    ))
                )
                lastNameSubtitleText.append(NSAttributedString(
                    string: "\(L.Profile.LastName.localization) ",
                    attributes: AttributedStringHelper.attributes(
                        font: .sourceSansProRegular(size: 12),
                        color: .grayGhost,
                        lineSpacing: 6
                    ))
                )
                let lastNameControl = ActionableControlWithBodyAndTitle(
                    attributedTitle: nil,
                    attributedBodyText: lastNameSubtitleText,
                    iconInBody: .pencil.withRenderingMode(.alwaysTemplate),
                    isFilled: true
                )
                stack.addArrangedSubview(lastNameControl)
                lastNameControl.widthToSuperview(offset: -48)
                lastNameControl.addTarget(self, action: #selector(nameControlClicked), for: .touchUpInside)
            }
            

            if let email = model.userResponse.email {
                let contactDetailsHeader = UILabel()
                let contactDetailsString = NSAttributedString(
                    string: L.Profile.ContactDetails.localization,
                    attributes: AttributedStringHelper.attributes(
                        font: UIFont.nunitoBold(size: 22),
                        color: .primaryColor,
                        lineSpacing: 10)
                )
                contactDetailsHeader.attributedText = contactDetailsString
                stack.setCustomSpacing(32, after: stack.arrangedSubviews.last!)
                stack.addArrangedSubview(contactDetailsHeader)
                
                contactDetailsHeader.widthToSuperview(offset: -48)
                let emailSubtitleText = NSMutableAttributedString(
                    string: "\(email)\n",
                    attributes: AttributedStringHelper.attributes(
                        font: .sourceSansProSemiBold(size: 16),
                        color: .backgroundColor,
                        lineSpacing: 6
                    ))
                emailSubtitleText.append(NSAttributedString(
                    string: "\(L.Profile.Email.localization) ",
                    attributes: AttributedStringHelper.attributes(
                        font: .sourceSansProRegular(size: 12),
                        color: .grayGhost,
                        lineSpacing: 6
                    ))
                )
                let emailControl = ActionableControlWithBodyAndTitle(
                    attributedTitle: nil,
                    attributedBodyText: emailSubtitleText,
                    iconInBody: .pencil.withRenderingMode(.alwaysTemplate),
                    isFilled: true
                )
                stack.addArrangedSubview(emailControl)
                emailControl.widthToSuperview(offset: -48)
                emailControl.addTarget(self, action: #selector(emailControlClicked), for: .touchUpInside)
            }
            
            
            // - Role & institution header
            
            let roleAndInstitutionHeader = UILabel()
            let roleAndInstitutionString = NSAttributedString(
                string: L.Profile.RoleAndInstitution.localization,
                attributes: AttributedStringHelper.attributes(
                    font: UIFont.nunitoBold(size: 22),
                    color: .primaryColor,
                    lineSpacing: 10)
            )
            roleAndInstitutionHeader.attributedText = roleAndInstitutionString
            stack.setCustomSpacing(32, after: stack.arrangedSubviews.last!)
            stack.addArrangedSubview(roleAndInstitutionHeader)
            roleAndInstitutionHeader.widthToSuperview(offset: -48)
            
            // Add institution cards
            for (_, linkedAccount) in (model.userResponse.linkedAccounts?.enumerated() ?? [].enumerated()) {
                for affiliation in linkedAccount.eduPersonAffiliations ?? [] {
                    
                    let createdAt: Date?
                    if let apiCreated = linkedAccount.createdAt {
                        createdAt = Date(timeIntervalSince1970: Double(apiCreated) / 1000)
                    } else {
                        createdAt = nil
                    }
                    let expiresAt: Date?
                    if let apiExpiresAt = linkedAccount.expiresAt {
                        expiresAt = Date(timeIntervalSince1970: Double(apiExpiresAt) / 1000)
                    } else {
                        expiresAt = nil
                    }
                    
                    let actionableControl = InstitutionControlCollapsible(
                        institution: linkedAccount.schacHomeOrganization ?? "",
                        verifiedAt: createdAt,
                        affiliation: affiliation,
                        expires: expiresAt
                    ) { [weak self] in
                        
                        // - alert to confirm service removal
                        let alert = UIAlertController(
                            title: L.Profile.RemoveServicePrompt.Title.localization,
                            message: L.Profile.RemoveServicePrompt.Description.localization,
                            preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: L.Profile.RemoveServicePrompt.Delete.localization, style: .destructive) { [weak self] action in
                            self?.viewModel.removeLinkedAccount(linkedAccount: linkedAccount)
                        })
                        alert.addAction(UIAlertAction(title: L.Profile.RemoveServicePrompt.Cancel.localization, style: .cancel) { _ in
                            alert.dismiss(animated: true)
                        })
                        self?.present(alert, animated: true)
                    }
                    stack.addArrangedSubview(actionableControl)
                    actionableControl.widthToSuperview(offset: -48)
                }
            }
            // - add add institution button
            let addInstitutionTitle = NSMutableAttributedString(string: "\(L.Profile.AddRoleAndInstitution.localization)\n\(L.Profile.AddViaSurfconext.localization)", attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 16), color: .grayGhost, lineSpacing: 6))
            addInstitutionTitle.setAttributeTo(part: L.Profile.AddViaSurfconext.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProItalic(size: 12), color: .grayGhost, lineSpacing: 6))
            addInstitutionButton = ActionableControlWithBodyAndTitle(
                attributedBodyText: addInstitutionTitle,
                iconInBody: UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate).withTintColor(.grayGhost),
                isFilled: false
            )
            addInstitutionButton.addTarget(self, action: #selector(addInstitutionClicked), for: .touchUpInside)
            
            stack.addArrangedSubview(addInstitutionButton)
            
            let manageAccountContainer = UIView()
            manageAccountContainer.backgroundColor = .disabledGrayBackground
            let manageAccountButton = EduIDButton(type: .ghost, buttonTitle: L.Profile.ManageYourAccount.localization)
            manageAccountButton.setImage(.cog, for: .normal)
            manageAccountButton.imageEdgeInsets = .right(32)
            manageAccountButton.addTarget(self, action: #selector(manageAccountClicked), for: .touchUpInside)
            manageAccountContainer.addSubview(manageAccountButton)
            manageAccountButton.edgesToSuperview(insets: .horizontal(24) + .vertical(20))
            stack.addArrangedSubview(manageAccountContainer)
            
            addInstitutionButton.widthToSuperview(offset: -48)
            manageAccountContainer.widthToSuperview()
            
            // Add click handlers
        } else {
            let loadingIndicator = UIActivityIndicatorView()
            stack.addArrangedSubview(loadingIndicator)
            loadingIndicator.height(80)
            loadingIndicator.widthToSuperview()
            loadingIndicator.startAnimating()
        }
        
        if previousScrollPosition > 0 {
            DispatchQueue.main.async { [weak scrollView] in
                scrollView?.setContentOffset(CGPoint(x: 0, y: previousScrollPosition), animated: false)
            }
        }
    }
    
    @objc func emailControlClicked() {
        delegate?.goToEmailEditor(viewController: self)
    }
    
    @objc func nameControlClicked() {
        if let personalInfo = viewModel.userResponse {
            delegate?.goToNameEditor(viewController: self, personalInfo: personalInfo)
        }
    }
    
    @objc func addInstitutionClicked() {
        self.addInstitutionButton.isEnabled = false
        self.addInstitutionButton.isLoading = true
        startLinkingInstitution()
    }
    
    @objc func verifyIdentityClicked() {
        self.verifyIdentityLoadingIndicator.startAnimating()
        self.verifyIdentityLoadingIndicator.isHidden = false
        startLinkingInstitution()
    }
    
    private func startLinkingInstitution() {
        Task {
            do {
                let link = try await self.viewModel.getStartLinkAccount()
                if let urlString = link?.url,
                   let url = URL(string: urlString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    let alert = UIAlertController(
                        title: L.Generic.RequestError.Title.localization,
                        message: L.Profile.AccountLinkError.Title.localization,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: L.Generic.RequestError.CloseButton.localization, style: .default) { _ in
                        alert.dismiss(animated: true)
                    })
                    self.present(alert, animated: true)
                }
            } catch {
                NSLog("Unable to fetch account link flow URL: \(error)")
                let alert = UIAlertController(
                    title: L.Generic.RequestError.Title.localization,
                    message: L.Generic.RequestError.Description(args: error.localizedDescription).localization,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: L.Generic.RequestError.CloseButton.localization, style: .default) { _ in
                    alert.dismiss(animated: true)
                })
                self.present(alert, animated: true)
            }
            self.addInstitutionButton.isLoading = false
            self.addInstitutionButton.isEnabled = true
            self.verifyIdentityLoadingIndicator.stopAnimating()
            self.verifyIdentityLoadingIndicator.isHidden = true
        }
    }
    
    @objc func manageAccountClicked() {
        guard let personalInfo = viewModel.userResponse else {
            return
        }
        delegate?.goToMyAccount(viewController: self, personalInfo: personalInfo)
    }
    
    @objc func dismissInfoScreen() {
        delegate?.personalInfoViewControllerDismissPersonalInfoFlow(viewController: self)
    }
}
