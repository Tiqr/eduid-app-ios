import UIKit
import TinyConstraints

class CreateEduIDAddInstitutionViewController: CreateEduIDBaseViewController {
    
    // - view model
    var viewModel: PersonalInfoViewModel

    // - verify button
    let continueButton = EduIDButton(type: .primary, buttonTitle: "Continue")
    
    // - views
    let scrollView = UIScrollView()
    private var stack: UIStackView!
    
    //MARK: - init
    init(viewModel: PersonalInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.viewController = self
        viewModel.dataAvailableClosure = { [weak self] model in
            self?.setupUI(model: model)
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
        screenType = .addInstitutionScreen        
        continueButton.addTarget(viewModel, action: #selector(viewModel.createAccount), for: .touchUpInside)
    }
    
    //MARK: - setup UI
    func setupUI(model: PersonalInfoDataCallbackModel) {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        // - posterLabel
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Your school/uni\nwas contacted successfully", size: 24, primary: "Your school/uni")
        
        // - create the textView
        let textLabelParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: """
The following information has been added to your eduID and can now be shared.
"""                                     , partBold: "")
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
        
        // - the info controls
        let nameTitle = NSAttributedString(string: LocalizedKey.Profile.name.localized, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .charcoalColor, lineSpacing: 6))
        let nameBodyText = NSMutableAttributedString(string: "\(model.name )\n\(LocalizedKey.Profile.providedBy.localized) \(model.nameProvidedBy )", attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .backgroundColor, lineSpacing: 6))
        nameBodyText.setAttributeTo(part: "\(LocalizedKey.Profile.providedBy.localized) \(model.nameProvidedBy )", attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .charcoalColor, lineSpacing: 6))
        let nameControl = ActionableControlWithBodyAndTitle(attributedTitle: nameTitle, attributedBodyText: nameBodyText, iconInBody: model.isNameProvidedByInstitution ? .shield.withRenderingMode(.alwaysOriginal) : UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), isFilled: true)
        
        // - create the stackview
        stack = UIStackView(arrangedSubviews: [posterLabel, textLabelParent, nameControl])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 20
        scrollView.addSubview(stack)
        
        // - institutions title
        let institutionsTitle = NSAttributedString(string: LocalizedKey.Profile.institution.localized, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .charcoalColor, lineSpacing: 6))
        let institutionsLabel = UILabel()
        institutionsLabel.attributedText = institutionsTitle
        let institutionTitleParent = UIView()
        institutionTitleParent.addSubview(institutionsLabel)
        institutionsLabel.edges(to: institutionTitleParent)
        stack.addArrangedSubview(institutionTitleParent)
        stack.setCustomSpacing(6, after: institutionTitleParent)
        
        let institutionControl = InstitutionControlCollapsible(role: Affiliation(rawValue: model.userResponse.linkedAccounts?.first?.eduPersonAffiliations?.first ?? "") ?? .employee, institution: model.userResponse.linkedAccounts?.first?.schacHomeOrganization ?? "", verifiedAt: Date(timeIntervalSince1970: Double(model.userResponse.linkedAccounts?.first?.createdAt ?? 0)), affiliation: model.userResponse.linkedAccounts?.first?.eduPersonAffiliations?.first ?? "", expires: Date(timeIntervalSince1970: Double(model.userResponse.linkedAccounts?.first?.expiresAt ?? 0))) { [weak self] in
            
            guard let linkedAccount = model.userResponse.linkedAccounts?.first else { return }
            
            // - alert to confirm service removal
            let alert = UIAlertController(title: LocalizedKey.Profile.removeServiceTitle.localized, message: LocalizedKey.Profile.removeServicePrompt.localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive) { [weak self] action in
                self?.viewModel.removeLinkedAccount(linkedAccount: linkedAccount)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.dismiss(animated: true)
            })
            self?.present(alert, animated: true)
        }
        stack.addArrangedSubview(institutionControl)
        institutionControl.width(to: stack)
        
        let spaceView = UIView()
        
        stack.addArrangedSubview(spaceView)
        stack.addArrangedSubview(continueButton)
        
        // - add constraints
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: -24))
        stack.width(to: scrollView, offset: -48)
        textLabel.width(to: stack)
        posterLabel.width(to: stack)
        nameControl.width(to: stack)
        posterLabel.height(68)
        continueButton.width(to: stack, offset: -24)
    }
}
