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
        
        viewModel.dataFetchErrorClosure = { [weak self] error in
            let alert = UIAlertController(title: L.ScanView.Error.localization, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L.PinAndBioMetrics.OKButton.localization, style: .default) { _ in
                alert.dismiss(animated: true)
            })
            self?.present(alert, animated: true)
        }
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
        Task {
            viewModel.getData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        if delegate?.shouldUpdateData() == true {
            Task {
                viewModel.getData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            viewModel.getData()
        }
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
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        // - Main title
        let mainTitle = UILabel.posterTextLabelBicolor(text: L.Profile.Title.localization, size: 24, primary:  L.Profile.Title.localization)
        
        // - Description below title
        let mainDescriptionParent = UIView()
        let mainDescription = UILabel.plainTextLabelPartlyBold(text: L.Profile.Info.localization, partBold: "")
        mainDescriptionParent.addSubview(mainDescription)
        mainDescription.edges(to: mainDescriptionParent)
        
        // Shareable information header
        let shareableInformationHeader = UILabel()
        let shareableInformationString = NSAttributedString(
            string: L.Profile.ShareableInformation.localization,
            attributes: AttributedStringHelper.attributes(
                font: UIFont.nunitoBold(size: 20),
                color: .primaryColor,
                lineSpacing: 10)
        )
        shareableInformationHeader.attributedText = shareableInformationString
        
        
        // - create the stackview
        stack = UIStackView(arrangedSubviews: [mainTitle, mainDescriptionParent, shareableInformationHeader])
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
        shareableInformationHeader.widthToSuperview(offset: -48)

                
        // Info controls
        if let model = model {
            let nameTitle = NSAttributedString(string: L.Profile.Name.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .charcoalColor, lineSpacing: 6))
            let nameSubtitleText = NSMutableAttributedString()
            nameSubtitleText.append(NSAttributedString(
                string: "\(model.name )\n",
                attributes: AttributedStringHelper.attributes(
                    font: .sourceSansProSemiBold(size: 16),
                    color: .backgroundColor,
                    lineSpacing: 6
                ))
            )
            nameSubtitleText.append(NSAttributedString(
                string: "\(L.Profile.ProvidedBy.localization) ",
                attributes: AttributedStringHelper.attributes(
                    font: .sourceSansProRegular(size: 12),
                    color: .charcoalColor,
                    lineSpacing: 6
                ))
            )
            nameSubtitleText.append(NSAttributedString(
                string: model.nameProvidedBy,
                attributes: AttributedStringHelper.attributes(
                    font: .sourceSansProSemiBold(size: 12),
                    color: .charcoalColor,
                    lineSpacing: 6
                ))
            )
            let nameControl = ActionableControlWithBodyAndTitle(
                attributedTitle: nameTitle,
                attributedBodyText: nameSubtitleText,
                iconInBody: model.isNameProvidedByInstitution ? .shield.withRenderingMode(.alwaysOriginal) : UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate),
                isFilled: true
            )
            
            let emailTitle = NSAttributedString(string: L.Profile.Email.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .charcoalColor, lineSpacing: 6))

            let emailProvidedByText = NSMutableAttributedString(
                string: "\(model.userResponse.email ?? "")\n",
                attributes: AttributedStringHelper.attributes(
                    font: .sourceSansProSemiBold(size: 16),
                    color: .backgroundColor,
                    lineSpacing: 6
            ))
            emailProvidedByText.append(NSAttributedString(
                string: "\(L.Profile.ProvidedBy.localization) ",
                attributes: AttributedStringHelper.attributes(
                    font: .sourceSansProRegular(size: 12),
                    color: .charcoalColor,
                    lineSpacing: 6
                ))
            )
            emailProvidedByText.append(NSAttributedString(
                string: L.Profile.Me.localization,
                attributes: AttributedStringHelper.attributes(
                    font: .sourceSansProSemiBold(size: 12),
                    color: .charcoalColor,
                    lineSpacing: 6
                ))
            )
            let emailControl = ActionableControlWithBodyAndTitle(
                attributedTitle: emailTitle,
                attributedBodyText: emailProvidedByText,
                iconInBody: .pencil,
                isFilled: true
            )
            
            stack.addArrangedSubview(nameControl)
            stack.addArrangedSubview(emailControl)

            // - Institutions title
            let institutionsLabel = UILabel()
            institutionsLabel.attributedText = NSAttributedString(
                string: L.Profile.RoleAndInstitution.localization,
                attributes: AttributedStringHelper.attributes(
                    font: .sourceSansProSemiBold(size: 16),
                    color: .charcoalColor,
                    lineSpacing: 6)
            )
            stack.addArrangedSubview(institutionsLabel)
            stack.setCustomSpacing(6, after: institutionsLabel)
            institutionsLabel.widthToSuperview(offset: -48)
            
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
                        role: Affiliation(rawValue: affiliation) ?? .employee,
                        institution: linkedAccount.schacHomeOrganization ?? "",
                        verifiedAt: createdAt,
                        affiliation: linkedAccount.eduPersonAffiliations?.first ?? "",
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
            
            nameControl.widthToSuperview(offset: -48)
            emailControl.widthToSuperview(offset: -48)
            addInstitutionButton.widthToSuperview(offset: -48)
            manageAccountContainer.widthToSuperview()
            
            // Add click handlers
            emailControl.addTarget(self, action: #selector(emailControlClicked), for: .touchUpInside)
            nameControl.addTarget(self, action: #selector(nameControlClicked), for: .touchUpInside)
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
    
    @objc
    func emailControlClicked() {
        delegate?.goToEmailEditor(viewController: self)
    }
    
    @objc
    func nameControlClicked() {
        if let personalInfo = viewModel.userResponse {
            delegate?.goToNameOverview(viewController: self, personalInfo: personalInfo)
        }
    }
    
    @objc
    func addInstitutionClicked() {
        self.addInstitutionButton.isEnabled = false
        self.addInstitutionButton.isLoading = true
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
        }
    }
    
    @objc
    func manageAccountClicked() {
        guard let personalInfo = viewModel.userResponse else {
            return
        }
        delegate?.goToMyAccount(viewController: self, personalInfo: personalInfo)
    }
    
    @objc
    func dismissInfoScreen() {
        delegate?.personalInfoViewControllerDismissPersonalInfoFlow(viewController: self)
    }
}

