import UIKit
import TinyConstraints

class PersonalInfoViewController: UIViewController, ScreenWithScreenType {
   
    // - screen type
    var screenType: ScreenType = .personalInfoLandingScreen
    
    // - delegate
    weak var delegate: PersonalInfoViewControllerDelegate?
    
    var viewModel: PersonalInfoViewModel
    
    private var stack: UIStackView!
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
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                alert.dismiss(animated: true)
            })
            self?.present(alert, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
    }
    
    //MARK: - setup UI
    func setupUI(model: PersonalInfoDataCallbackModel) {
        
        // - scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        // - posterLabel
        let posterLabel = UILabel.posterTextLabelBicolor(
            text: R.string.localizable.profileTitle(),
            size: 24,
            primary: R.string.localizable.profileTitle()
        )
        
        // - create the textView
        let textLabelParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: R.string.localizable.profileInfoText(), partBold: "")
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
                
        // - the info controls
        let nameTitle = NSAttributedString(string: R.string.localizable.profileName(), attributes: AttributedStringHelper.attributes(font: R.font.sourceSansProSemiBold(size: 16)!, color: R.color.charcoalColor()!, lineSpacing: 6))
        let nameBodyText = NSMutableAttributedString(string: "\(model.name )\n\(R.string.localizable.profileProvidedBy()) \(model.nameProvidedBy )", attributes: AttributedStringHelper.attributes(font: R.font.sourceSansProSemiBold(size: 16)!, color: R.color.backgroundColor()!, lineSpacing: 6))
        nameBodyText.setAttributeTo(part: "\(R.string.localizable.profileProvidedBy()) \(model.nameProvidedBy )", attributes: AttributedStringHelper.attributes(font: R.font.sourceSansProRegular(size: 12)!, color: R.color.charcoalColor()!, lineSpacing: 6))
        let nameControl = ActionableControlWithBodyAndTitle(attributedTitle: nameTitle, attributedBodyText: nameBodyText, iconInBody: model.isNameProvidedByInstitution ? R.image.shield()!.withRenderingMode(.alwaysOriginal) : UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), isFilled: true)
        
        let emailTitle = NSAttributedString(string: R.string.localizable.profileEmail(), attributes: AttributedStringHelper.attributes(font: R.font.sourceSansProSemiBold(size: 16)!, color: R.color.charcoalColor()!, lineSpacing: 6))
        let emailBodyText = NSMutableAttributedString(string: "\(model.userResponse.email ?? "")\n\(R.string.localizable.profileProvidedBy()) \(R.string.localizable.profileMe())", attributes: AttributedStringHelper.attributes(font: R.font.sourceSansProSemiBold(size: 16)!, color: R.color.backgroundColor()!, lineSpacing: 6))
        emailBodyText.setAttributeTo(part: "\(R.string.localizable.profileProvidedBy()) \(R.string.localizable.profileMe())", attributes: AttributedStringHelper.attributes(font: R.font.sourceSansProRegular(size: 12)!, color: R.color.charcoalColor()!, lineSpacing: 6))
        let emailControl = ActionableControlWithBodyAndTitle(attributedTitle: emailTitle, attributedBodyText: emailBodyText, iconInBody: R.image.pencil()!, isFilled: true)
        
        
        // - create the stackview
        stack = UIStackView(arrangedSubviews: [posterLabel, textLabelParent, nameControl, emailControl])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 20
        scrollView.addSubview(stack)
        
        // - institutions title
        let institutionsTitle = NSAttributedString(string: R.string.localizable.profileInstitution(), attributes: AttributedStringHelper.attributes(font: R.font.sourceSansProSemiBold(size: 16)!, color: R.color.charcoalColor()!, lineSpacing: 6))
        let institutionsLabel = UILabel()
        institutionsLabel.attributedText = institutionsTitle
        let institutionTitleParent = UIView()
        institutionTitleParent.addSubview(institutionsLabel)
        institutionsLabel.edges(to: institutionTitleParent)
        stack.addArrangedSubview(institutionTitleParent)
        stack.setCustomSpacing(6, after: institutionTitleParent)
        
        // - add institutions
        for (_, linkedAccount) in (model.userResponse.linkedAccounts?.enumerated() ?? [].enumerated()) {
            for affiliation in linkedAccount.eduPersonAffiliations ?? [] {
                let actionableControl = InstitutionControlCollapsible(role: Affiliation(rawValue: affiliation) ?? .employee, institution: linkedAccount.schacHomeOrganization ?? "", verifiedAt: Date(timeIntervalSince1970: Double(linkedAccount.createdAt ?? 0)), affiliation: linkedAccount.eduPersonAffiliations?.first ?? "", expires: Date(timeIntervalSince1970: Double(linkedAccount.expiresAt ?? 0))) { [weak self] in
                    
                    // - alert to confirm service removal
                    let alert = UIAlertController(title: R.string.localizable.profilePromptRemoveServiceTitle(), message: R.string.localizable.profilePromptRemoveService(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { [weak self] action in
                        self?.viewModel.removeLinkedAccount(linkedAccount: linkedAccount)
                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                        alert.dismiss(animated: true)
                    })
                    self?.present(alert, animated: true)
                }
                stack.addArrangedSubview(actionableControl)
                actionableControl.width(to: stack)
            }
        }
        // - add add institution button
        let addInstitutionTitle = NSMutableAttributedString(string: "\(R.string.localizable.profileAddRoleInstitution())\nproceed to add this via SURFconext", attributes: AttributedStringHelper.attributes(font: R.font.sourceSansProSemiBold(size: 16)!, color: R.color.charcoalColor()!, lineSpacing: 6))
        addInstitutionTitle.setAttributeTo(part: "proceed to add this via SURFconext", attributes: AttributedStringHelper.attributes(font: R.font.sourceSansProLight(size: 12)!, color: R.color.charcoalColor()!, lineSpacing: 6))
        let addInstitutionButton = ActionableControlWithBodyAndTitle(attributedBodyText: addInstitutionTitle, iconInBody: UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate), isFilled: false)
        
        stack.addArrangedSubview(addInstitutionButton)
        
        // - add constraints
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: -24))
        stack.width(to: scrollView, offset: -48)
        textLabel.width(to: stack)
        posterLabel.width(to: stack)
        nameControl.width(to: stack)
        emailControl.width(to: stack)
        addInstitutionButton.width(to: stack)
    }
    
    @objc
    func dismissInfoScreen() {
        delegate?.personalInfoViewControllerDismissPersonalInfoFlow(viewController: self)
    }
}
