import UIKit
import TinyConstraints

class CreateEduIDEnterPersonalInfoViewController: ScrollingTextFieldsViewController {
    
    static var emailKeyUserDefaults = "emailKeyUserDefaults"
    
    weak var delegate: CreateEduIDViewControllerDelegate?
    
    private var viewModel: CreateEduIDEnterPersonalInfoViewModel
    private let inset: CGFloat = 24
    
    static let lastNameFieldTag = 3
    static let firstNameFieldTag = 2
    static let emailFieldTag = 1
   
    var requestButton: EduIDButton!
    let theSwitch = UISwitch()
    
    var firstNameField: TextFieldViewWithValidationAndTitle!
    var lastNameField: TextFieldViewWithValidationAndTitle!
    let emailField = TextFieldViewWithValidationAndTitle(title: "Your email address", placeholder: "e.g. timbernerslee@gmail.com", field: .email, keyboardType: .emailAddress)
    
    var textFieldsAreValid: Bool = false {
        didSet {
            requestButton.isEnabled = textFieldsAreValid && theSwitch.isOn
        }
    }
    
    // - spacing
    let spacingView = UIView()
    
    //MARK: - init
    init(viewModel: CreateEduIDEnterPersonalInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        screenType = .enterInfoScreen
        
        let loadedTime = Date()
        
        viewModel.makeNextTextFieldFirstResponderClosure = { [weak self] tag in
            guard tag != CreateEduIDEnterPersonalInfoViewController.lastNameFieldTag else {
                self?.resignKeyboardResponder()
                return
            }
            //tag + 2 because the stackview's first subview is the poster label and we need the subview after the current, hence + 2
            _ = (self?.stack.arrangedSubviews[tag + 1] as? TextFieldViewWithValidationAndTitle)?.becomeFirstResponder()
            self?.scrollViewToTextField(index: tag + 1)
        }
        
        viewModel.setRequestButtonEnabled = { [weak self] isEnabled in
            self?.textFieldsAreValid = isEnabled
        }
        
        viewModel.textFieldBecameFirstResponderClosure = { [weak self] tag in
            guard Date().timeIntervalSince(loadedTime) > 1 else { return }
            self?.scrollViewToTextField(index: tag)
        }
        
        viewModel.createEduIDErrorClosure = { [weak self] error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                alert.dismiss(animated: true)
            })
            self?.present(alert, animated: true)
        }
        
        viewModel.createEduIDSuccessClosure = { [weak self] in
            self?.showNextScreen()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboardResponder)))
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stack.animate(onlyThese: [1, 2, 3, 4, 6])
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(goBack))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //set the height of the spacer according to the view
        if scrollView.frame.size.height > scrollView.contentSize.height + CreateEduIDEnterPersonalInfoViewController.smallBuffer {
            spacingView.height(scrollView.frame.size.height - scrollView.contentSize.height - inset - view.safeAreaInsets.top)
        }
        
        _ = emailField.becomeFirstResponder()
    }
    
    //MARK: - setup UI
    private func setupUI() {
        
        let localizedString1 = NSLocalizedString(LocalizedKey.Login.requestEduIdButton, comment: "")
        requestButton = EduIDButton(type: .primary, buttonTitle: localizedString1)
        
        // - add scrollview to hierarchy
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        
        // - poster text
        let posterLabel = UILabel.posterTextLabel(text: "Request your eduID", size: 24)
        
        // - email
        emailField.tag = CreateEduIDEnterPersonalInfoViewController.emailFieldTag
        emailField.delegate = viewModel
        
        // - firstname
        firstNameField = TextFieldViewWithValidationAndTitle(title: "First name", placeholder: "e.g. Tim", field: .name, keyboardType: .default)
        firstNameField.tag = CreateEduIDEnterPersonalInfoViewController.firstNameFieldTag
        firstNameField.delegate = viewModel
        
        // - lastName
        lastNameField = TextFieldViewWithValidationAndTitle(title: "Last name", placeholder: "e.g. Berners-Lee", field: .name, keyboardType: .default)
        lastNameField.tag = CreateEduIDEnterPersonalInfoViewController.lastNameFieldTag
        lastNameField.delegate = viewModel
        
        // - check terms
        let termsHstack = UIStackView()
        termsHstack.spacing = 10
        termsHstack.axis = .horizontal
        termsHstack.height(36)
        
        theSwitch.onTintColor = .primaryColor
        theSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        
        let termsLabel = UILabel()
        termsLabel.font = .sourceSansProRegular(size: 12)
        termsLabel.textColor = .charcoalColor
        termsLabel.numberOfLines = 2
        termsLabel.text = "I agree with the terms of service. I also understand the privacy policy."
        
        termsHstack.addArrangedSubview(theSwitch)
        termsHstack.addArrangedSubview(termsLabel)
        
        // - requestButton
        requestButton.isEnabled = false
        requestButton.addTarget(self, action: #selector(createEduIDAction), for: .touchUpInside)
        
        // - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterLabel, emailField, firstNameField, lastNameField, termsHstack, spacingView, requestButton])
        stack.spacing = 32
        stack.setCustomSpacing(24, after: emailField)
        stack.setCustomSpacing(24, after: firstNameField)
        stack.setCustomSpacing(4, after: lastNameField)
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        
        scrollView.addSubview(stack)
        
        // - add constraints
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: inset, left: inset, bottom: inset, right: -inset))
        stack.width(to: scrollView, offset: -(2 * inset))
        
        posterLabel.height(34)
        requestButton.width(to: stack, offset: -inset)
        emailField.width(to: stack)
        firstNameField.width(to: stack)
        lastNameField.width(to: stack)
        
        stack.hideAndTriggerAll(onlyThese: [1, 2, 3, 4, 6])
    }
    
    //MARK: - actions
    @objc
    func switchToggled() {
        requestButton.isEnabled = theSwitch.isOn && textFieldsAreValid
        self.view.endEditing(true)
    }

    @objc
    func createEduIDAction() {
        UserDefaults.standard.set(emailField.textField.text, forKey: CreateEduIDEnterPersonalInfoViewController.emailKeyUserDefaults)
        viewModel.createEduID(familyName: lastNameField.textField.text ?? "", givenName: firstNameField.textField.text ?? "", email: emailField.textField.text ?? "")
    }
    
    override func goBack() {
        delegate?.goBack(viewController: self)
    }
    
    func showNextScreen() {
        delegate?.createEduIDViewControllerShowNextScreen(viewController: self)
    }
}

