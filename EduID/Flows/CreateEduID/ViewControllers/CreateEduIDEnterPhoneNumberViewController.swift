import UIKit
import TinyConstraints
import OpenAPIClient

class CreateEduIDEnterPhoneNumberViewController: CreateEduIDBaseViewController, ValidatedTextFieldDelegate {
    
    var stack: AnimatedVStackView!
    
    // - phone textfield
    let validatedPhoneTextField = TextFieldViewWithValidationAndTitle(title: "Enter your phone number", placeholder: "e.g. 0612345678", field: .phone, keyboardType: .numberPad)
    
    // - verify button
    let verifyButton = EduIDButton(type: .primary, buttonTitle: "Verify this phone number")
    
    private var viewModel: CreateEduIDEnterPhoneNumberViewModel
    
    //MARK: - init
    init(viewModel: CreateEduIDEnterPhoneNumberViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.phoneNumberReceivedClosure = { [weak self] result in
            self?.showNextScreen2()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .enterPhoneScreen
        
        setupUI()
        verifyButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboardResponder)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stack.animate(onlyThese: [2])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = validatedPhoneTextField.becomeFirstResponder()
    }
    
    //MARK: - setup UI
    func setupUI() {
        
        // - phone textfield delegate
        validatedPhoneTextField.delegate = self
        
        // - button state
        verifyButton.isEnabled = false
        
        // - posterLabel
        let posterLabel = UILabel.posterTextLabel(text: "Your eduID has been created", size: 24)
        
        // - textView Parent
        let textViewParent = UIView()
        
        // - create the textView
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = R.font.sourceSansProLight(size: 16)
        textLabel.textColor = .secondaryColor
        let attributedText = NSMutableAttributedString(string:
"""
Let’s add a recovery phonenumber
If you can't access eduID with the app or via email, you can use this to sign in to your eduID Account.

We will text you a code to verify your number.
"""
                                                ,attributes: [.font : R.font.sourceSansProLight(size: 16)])
        attributedText.setAttributes([.font : R.font.sourceSansProSemiBold(size: 16)], range: NSRange(location: 0, length: 32))
        textLabel.attributedText = attributedText
        
        textViewParent.addSubview(textLabel)
        textLabel.edges(to: textViewParent)
        textLabel.sizeToFit()
        
        // - Space
        let spaceView = UIView()
        
        // - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterLabel, textViewParent, validatedPhoneTextField, spaceView, verifyButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        // - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        textViewParent.width(to: stack)
        posterLabel.height(34)
        verifyButton.width(to: stack, offset: -24)
        validatedPhoneTextField.width(to: stack)
        
        stack.hideAndTriggerAll(onlyThese: [2])
    }
    
    //MARK: - textfield validation method
    func updateValidation(with value: String, isValid: Bool, from tag: Int) {
        verifyButton.isEnabled = isValid
    }
    
    func keyBoardDidReturn(tag: Int) {
        resignKeyboardResponder()
    }
    
    func didBecomeFirstResponder(tag: Int) {
    }
    
    @objc
    func resignKeyboardResponder() {
        _ = validatedPhoneTextField.resignFirstResponder()
    }
    
    override func showNextScreen() {
        viewModel.sendPhoneNumber(number: validatedPhoneTextField.textField.text ?? "")
    }
    
    func showNextScreen2() {
        (delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: self)
    }
}
